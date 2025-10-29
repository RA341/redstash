package downloader

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/RA341/redstash/internal/reddit"
	"github.com/RA341/redstash/pkg/schd"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"golang.org/x/sync/errgroup"
)

type UpdatePostFn func(post *reddit.Post) error

type Service struct {
	downloadDir        string
	store              reddit.PostStore
	maxDownloadWorkers int
	maxPostsToFetch    int
	updatePost         UpdatePostFn

	downloaderFnMap map[string]Downloader
	triggerChan     chan struct{}
	Task            *schd.Scheduler
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
		store:       store,
		downloadDir: downloadDir,

		maxDownloadWorkers: 30,
		maxPostsToFetch:    100,

		updatePost:      updatePost,
		downloaderFnMap: downloaderMap,
	}

	// todo move to config
	downloadCheckInterval := time.Hour

	s.Task = schd.NewScheduler(
		s.StartDownloader,
		downloadCheckInterval,
	)

	return s
}

func (s *Service) StartDownloader() {
	log.Info().Msg("downloader started")

	postChan := make(chan *reddit.Post, s.maxPostsToFetch)

	wg := errgroup.Group{}
	wg.Go(func() error {
		return s.postProducer(postChan)
	})
	wg.Go(func() error {
		s.deployWorkers(postChan)
		return nil
	})

	err := wg.Wait()
	if err != nil {
		log.Error().Err(err).Msg("failed to start downloader")
	}

	log.Info().Msg("downloader completed")
}

func (s *Service) postProducer(postChannel chan *reddit.Post) error {
	const strikeLimit = 5

	strikes := 0

	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	posts := make([]reddit.Post, 0, s.maxPostsToFetch)

	for {
		select {
		case <-ticker.C:
			posts = posts[:0] // clear slice
			err := s.store.ListNonDownloaded(s.maxPostsToFetch, &posts)
			if err != nil {
				return err
			}
			log.Debug().Int("posts", len(posts)).Msg("posts found")

			for _, post := range posts {
				if post.DownloadData != nil {
					log.Info().Str("id", post.RedditId).Msg("post already downloaded")
					continue
				}
				postChannel <- &post
			}

			// Check if we got fewer results than expected
			if len(posts) < s.maxPostsToFetch {
				strikes++
				if strikes >= strikeLimit {
					log.Info().Msg("Exiting downloader")
					close(postChannel)
					return nil
				}
				log.Info().
					Int("strike", strikes).Int("strikes left", strikeLimit-strikes).
					Msg("strikes left before downloader stops")
			}
		}
	}
}

func (s *Service) deployWorkers(postChannel chan *reddit.Post) {
	workerSem := make(chan struct{}, s.maxDownloadWorkers)

	worker := func(post *reddit.Post) {
		subLogger := log.With().Str("post", post.RedditId).Logger()

		err := s.download(&subLogger, post)
		if err != nil {
			post.ErrorData = err.Error()
		}

		err = s.updatePost(post)
		if err != nil {
			subLogger.Err(err).Msg("failed to update post")
		}

		<-workerSem // release
	}

	for {
		select {
		case post, ok := <-postChannel:
			if !ok {
				log.Debug().Msg("Post Consumer: post channel closed")
				return
			}
			workerSem <- struct{}{} // acquire
			go worker(post)
		}
	}
}

func (s *Service) download(log *zerolog.Logger, post *reddit.Post) error {
	log.Info().Msg("Downloading post")

	baseFolder := filepath.Join(s.downloadDir, post.RedditId)
	err := os.MkdirAll(baseFolder, 0755)
	if err != nil {
		return fmt.Errorf("unable to create download directory at %s, err: %w", baseFolder, err)
	}

	downloadFn, ok := s.downloaderFnMap[string(post.MediaType)]
	if !ok {
		return fmt.Errorf("unsupported media type %s", string(post.MediaType))
	}

	err = downloadFn(post, baseFolder)
	if err != nil {
		return fmt.Errorf("error occured while downloading %w", err)
	}

	return nil
}
