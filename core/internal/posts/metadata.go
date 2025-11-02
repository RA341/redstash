package posts

import (
	"encoding/json"
	"fmt"
	"image"
	"os"

	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/reddit"
	"github.com/RA341/redstash/pkg/fileutil"
	"github.com/abema/go-mp4"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type MetadataStore interface {
	UpdateMetadata(posts *reddit.Post) error

	// ListNonTaggedPosts gets all posts with no media metadata
	ListNonTaggedPosts(limit int, posts []reddit.Post) ([]reddit.Post, error)

	// SetAllToUntagged sets all rows to untagged
	SetAllToUntagged() error
}

type MediaMetadataService struct {
	store      MetadataStore
	log        *zerolog.Logger
	maxWorkers uint
	limit      uint
}

func NewMediaMetadataService(store MetadataStore) *MediaMetadataService {
	logger := log.With().Fields([]interface{}{"service", "metadata"}).Logger()

	return &MediaMetadataService{
		store:      store,
		log:        &logger,
		maxWorkers: 20,
		limit:      20,
	}
}

// TagMedia tags all untagged media
func (s *MediaMetadataService) TagMedia() {
	workerSem := make(chan struct{}, s.maxWorkers)
	posts := make([]reddit.Post, 0, s.limit)
	for {
		var err error
		posts, err = s.store.ListNonTaggedPosts(int(s.limit), posts)
		if err != nil {
			s.log.Err(err).Msg("Error listing posts")
		}

		for _, post := range posts {
			workerSem <- struct{}{} // acquire
			go s.worker(workerSem, &post)
		}

		if len(posts) < int(s.limit) {
			s.log.Info().Msg("done tagging media")
			return
		}
	}
}

func (s *MediaMetadataService) worker(sem chan struct{}, post *reddit.Post) {
	defer func() { <-sem }()

	var data []byte

	switch post.MediaType {
	case reddit.Image:
		var img downloader.Image
		// returns true if fails
		if s.unmarshal(post, &img) {
			return
		}

		dimensions, err := getImageRatio(img.Path)
		if err != nil {
			s.log.Err(err).Msg("Error getting image ratio")
			return
		}
		img.Ratio = dimensions

		var errored bool
		data, errored = s.marshal(img)
		if errored {
			return
		}
	case reddit.Gallery:
		var gal downloader.Gallery
		// returns true if fails
		if s.unmarshal(post, &gal) {
			return
		}

		for i, img := range gal.ImgList {
			dimensions, err := getImageRatio(img.Path)
			if err != nil {
				s.log.Err(err).Msg("Error getting image ratio")
				return
			}
			img.Ratio = dimensions
			gal.ImgList[i] = img
		}

		var errored bool
		data, errored = s.marshal(gal)
		if errored {
			return
		}
	case reddit.Video:
		var img downloader.Image
		// returns true if fails
		if s.unmarshal(post, &img) {
			return
		}

		dimensions, err := getMp4Dimensions(img.Path)
		if err != nil {
			s.log.Err(err).Msg("Error getting image ratio")
			return
		}
		img.Ratio = dimensions

		var errored bool
		data, errored = s.marshal(img)
		if errored {
			return
		}
	}

	post.DownloadData = data
	post.MediaMetadataTagged = true

	err := s.store.UpdateMetadata(post)
	if err != nil {
		s.log.Err(err).Str("post", post.RedditId).Msg("Error updating metadata")
		return
	}
}

func (s *MediaMetadataService) marshal(img any) ([]byte, bool) {
	data, err := json.Marshal(&img)
	if err != nil {
		s.log.Err(err).Msg("Error marshalling struct")
		return nil, true
	}
	return data, false
}

func (s *MediaMetadataService) unmarshal(post *reddit.Post, img any) bool {
	err := json.Unmarshal(post.DownloadData, img)
	if err != nil {
		s.log.Err(err).Str("post", post.RedditId).Msg("unable to unmarshal image")
		return true
	}
	return false
}

func getMp4Dimensions(filepath string) (float32, error) {
	file, err := os.OpenFile(filepath, os.O_RDONLY, os.ModePerm)
	if err != nil {
		return 0, err
	}
	defer fileutil.Close(file)

	boxes, err := mp4.ExtractBoxWithPayload(
		file,
		nil,
		mp4.BoxPath{mp4.BoxTypeMoov(), mp4.BoxTypeTrak(), mp4.BoxTypeTkhd()},
	)
	if err != nil {
		return 0, fmt.Errorf("failed to extract metadata boxes for mp4: %w", err)
	}

	if len(boxes) < 1 {
		return 0, fmt.Errorf("%s no metadata boxes found: probably not a video file, who TF knows", filepath)
	}

	width := boxes[0].Payload.(*mp4.Tkhd).GetWidthInt()
	height := boxes[0].Payload.(*mp4.Tkhd).GetHeightInt()

	return getMediaRatio(width, height), nil
}

func getImageRatio(filepath string) (float32, error) {
	file, err := os.OpenFile(filepath, os.O_RDONLY, os.ModePerm)
	if err != nil {
		return 0, err
	}
	defer fileutil.Close(file)

	// DecodeConfig reads the minimal amount of data required to determine
	// the image's format and bounds. It does NOT decode the whole image.
	config, _, err := image.DecodeConfig(file)
	if err != nil {
		return 0, err
	}

	return getMediaRatio(uint16(config.Width), uint16(config.Height)), nil
}

func getMediaRatio(width uint16, height uint16) float32 {
	videoRatio := float64(width) / float64(height)

	if videoRatio >= 1.0 {
		// Landscape or Square (Wider than or equal to 1:1)
		// Common landscape/square standards: 16:9 (1.77) or 4:3 (1.33)
		return 16.0 / 9.0 // Assigns ~1.777
	}

	// Portrait (Taller than 1:1)
	// Common portrait standards: 9:16 (~0.56) or 3:4 (0.75)
	// To set a common portrait ratio, you would use its inverse, e.g., 9:16 or 4:5.
	return 3.0 / 4.0 // Assigns 0.8

}
