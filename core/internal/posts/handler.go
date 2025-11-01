package posts

import (
	"context"
	"encoding/json"
	"image"
	"os"

	"connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/posts/v1"
	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/reddit"
	"github.com/RA341/redstash/pkg/fileutil"
	"github.com/abema/go-mp4"
	"github.com/rs/zerolog/log"

	// Import the format packages you want to support for DecodeConfig
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) *Handler {
	return &Handler{srv: srv}
}

func (h *Handler) ListDownloaded(ctx context.Context, c *connect.Request[v1.ListDownloadedRequest]) (*connect.Response[v1.ListDownloadedResponse], error) {
	msg := c.Msg
	limit := msg.Limit
	off := msg.Offset
	acc := msg.Userid

	downloaded, err := h.srv.ListDownloaded(int(off), int(limit), int(acc))
	if err != nil {
		return nil, err
	}

	result := make([]*v1.Post, 0, len(downloaded))
	for _, post := range downloaded {
		var resItem v1.Post

		switch post.MediaType {
		case reddit.Gallery:
			var img downloader.Gallery

			err = json.Unmarshal(post.DownloadData, &img)
			if err != nil {
				log.Warn().Err(err).Msg("failed to unmarshal gallery")
				break
			}

			var apiItems []*v1.Media
			for _, g := range img.ImgList {
				width, height, err := getImageDimensions(g.Path)
				if err != nil {
					return nil, err
				}

				ratio := getMediaRatio(uint16(width), uint16(height))

				apiItems = append(apiItems, &v1.Media{
					Url:   h.srv.EncodeFileLink(g.Path),
					Ratio: ratio,
				})
			}

			resItem.Gallery = apiItems
		case reddit.Image, reddit.Video:

			var img downloader.Image

			err = json.Unmarshal(post.DownloadData, &img)
			if err != nil {
				log.Warn().Err(err).Msg("failed to unmarshal image")
				continue
			}

			var med v1.Media

			if post.MediaType == reddit.Video {
				file, err := os.OpenFile(img.Path, os.O_RDONLY, os.ModePerm)
				if err != nil {
					log.Warn().Err(err).Msg("failed to open file")
					continue
				}

				boxes, err := mp4.ExtractBoxWithPayload(
					file,
					nil,
					mp4.BoxPath{mp4.BoxTypeMoov(), mp4.BoxTypeTrak(), mp4.BoxTypeTkhd()},
				)
				if err != nil {
					log.Warn().Err(err).Msg("failed to extract boxes")
					continue
				}

				if len(boxes) > 0 {
					width := boxes[0].Payload.(*mp4.Tkhd).GetWidthInt()
					height := boxes[0].Payload.(*mp4.Tkhd).GetHeightInt()

					med.Ratio = getMediaRatio(width, height)
				} else {
					log.Warn().Err(err).Str("id", post.RedditId).Msg("failed to get mp4 dimensions")
				}
			} else {
				width, height, err := getImageDimensions(img.Path)
				if err != nil {
					log.Warn().Err(err).Msg("failed to get media size")
					continue
				}
				med.Ratio = getMediaRatio(uint16(width), uint16(height))
			}

			med.Url = h.srv.EncodeFileLink(img.Path)
			resItem.DirectLink = &med
		}

		resItem.RedditId = post.RedditId
		resItem.Title = post.Title
		resItem.Subreddit = post.Subreddit
		resItem.RedditCreated = post.CreatedReddit.Unix()

		result = append(result, &resItem)
	}

	return connect.NewResponse(&v1.ListDownloadedResponse{Posts: result}), nil
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

func getImageDimensions(filePath string) (width, height int, err error) {
	file, err := os.Open(filePath)
	if err != nil {
		return 0, 0, err
	}
	defer fileutil.Close(file)

	// DecodeConfig reads the minimal amount of data required to determine
	// the image's format and bounds. It does NOT decode the whole image.
	config, _, err := image.DecodeConfig(file)
	if err != nil {
		return 0, 0, err
	}

	return config.Width, config.Height, nil
}
