package posts

import (
	"context"
	"encoding/json"

	"connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/posts/v1"
	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/reddit"
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
				apiItems = append(apiItems, &v1.Media{
					Url:   h.srv.EncodeFileLink(g.Path),
					Ratio: getRatio(g),
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

			resItem.DirectLink = &v1.Media{
				Url:   h.srv.EncodeFileLink(img.Path),
				Ratio: getRatio(img),
			}
		}

		resItem.RedditId = post.RedditId
		resItem.Title = post.Title
		resItem.Subreddit = post.Subreddit
		resItem.RedditCreated = post.CreatedReddit.Unix()

		result = append(result, &resItem)
	}

	return connect.NewResponse(&v1.ListDownloadedResponse{Posts: result}), nil
}

func getRatio(img downloader.Image) float32 {
	if img.Ratio == 0 {
		return float32(16 / 9)
	}

	return img.Ratio
}
