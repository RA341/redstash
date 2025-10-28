package downloader

import (
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/RA341/redstash/internal/reddit"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"golang.org/x/sync/errgroup"
)

type UpdatePostFn func(post *reddit.Post) error

type Service struct {
	downloadDir        string
	store              reddit.PostStore
	maxDownloadWorkers int

	updatePost UpdatePostFn

	downloaderMap map[string]Downloader
	triggerChan   chan interface{}
}

func NewService(downloadDir string, store reddit.PostStore, updatePost UpdatePostFn) *Service {
	client := NewClient()
	err := client.Login()
	if err != nil {
		log.Warn().Err(err).Msg("Failed to login")
	}

	var downloaderMap = map[string]Downloader{
		string(reddit.Gallery): downloadGallery,
		string(reddit.Image):   downloadImage,
		string(reddit.Video): func(post *reddit.Post, downloadDir string) error {
			return downloadVideo(post, downloadDir, client)
		},
	}

	s := &Service{
		store:              store,
		downloadDir:        downloadDir,
		maxDownloadWorkers: 50,
		updatePost:         updatePost,
		downloaderMap:      downloaderMap,
		triggerChan:        make(chan interface{}, 1),
	}

	s.TriggerDownloader()
	return s
}

func (s *Service) TriggerDownloader() {
	go func() {
		select {
		case s.triggerChan <- struct{}{}:
			log.Info().Msg("downloader started")
			s.StartDownloader()
			log.Info().Msg("downloader complete")

			_ = <-s.triggerChan
		default:
			log.Info().Msg("downloader is already running")
		}
	}()
}

func (s *Service) StartDownloader() {
	postChan := make(chan reddit.Post, 100)

	wg := errgroup.Group{}
	wg.Go(func() error {
		return s.StartDatabaseFeeder(postChan)
	})
	wg.Go(func() error {
		s.DeployWorkers(postChan)
		return nil
	})

	err := wg.Wait()
	if err != nil {
		log.Error().Err(err).Msg("failed to start downloader")
	}

	log.Info().Msg("downloader finished")
}

func (s *Service) StartDatabaseFeeder(postChannel chan reddit.Post) error {
	const strikeLimit = 5

	limit := 100
	strikes := 0

	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			posts, err := s.store.ListNonDownloaded(limit)
			if err != nil {
				return err
			}

			for _, post := range posts {
				if post.DownloadData != nil {
					log.Info().Str("id", post.RedditId).Msg("post already downloaded")
					continue
				}
				postChannel <- post
			}

			// Check if we got fewer results than expected
			if len(posts) < limit {
				strikes++
				if strikes >= strikeLimit {
					log.Info().Msg("Exiting downloader")
					close(postChannel)
					return nil
				}
				log.Info().
					Int("strike", strikes).Int("strikes left", strikeLimit-strikes).
					Msg("strikes left before downloader stops")
			} else {
				// We got full results, reset strikes and continue pagination
				strikes = 0
			}
		}
	}
}

func (s *Service) DeployWorkers(postChannel chan reddit.Post) {
	wg := sync.WaitGroup{}

	for i := 0; i < s.maxDownloadWorkers; i++ {
		wg.Go(func() {
			s.DownloadWorker(i+1, postChannel)
		})
	}

	wg.Wait()
	log.Info().Msg("all workers finished")
}

func (s *Service) DownloadWorker(workerID int, postChannel chan reddit.Post) {
	subLogger := log.With().Int("Worker", workerID).Logger()

	for {
		select {
		case post, ok := <-postChannel:
			if !ok {
				subLogger.Info().Msg("Post channel closed exiting worker")
				return
			}

			s.StartDownload(subLogger, &post)
		}
	}
}

func (s *Service) StartDownload(log zerolog.Logger, post *reddit.Post) {
	baseFolder := filepath.Join(s.downloadDir, post.RedditId)
	err := os.MkdirAll(baseFolder, 0755)
	if err != nil {
		log.Warn().Str("filepath", baseFolder).Msg("unable to create download directory")
		return
	}

	downloadFn, ok := s.downloaderMap[string(post.MediaType)]
	if !ok {
		log.Warn().Str("type", string(post.MediaType)).Msg("Unsupported media type")
		return
	}

	err = downloadFn(post, baseFolder)
	if err != nil {
		post.ErrorData = err.Error()
	}

	err = s.updatePost(post)
	if err != nil {
		log.Error().Err(err).Msg("unable to update post")
	}
}
