package posts

import (
	"context"
	"encoding/json"
	"fmt"

	connect "connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/posts/v1"
	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/reddit"
	"github.com/rs/zerolog/log"
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

		var redditData map[string]interface{}
		err := json.Unmarshal(post.Data, &redditData)
		if err != nil {
			log.Warn().Err(err).Msg("failed to unmarshal reddit data")
			continue
		}
		title, ok := redditData["title"].(string)
		if !ok {
			log.Warn().Msg("reddit title is not a string")
			continue
		}
		resItem.Title = title

		switch post.MediaType {
		case reddit.Gallery:
			var img downloader.Gallery

			err := json.Unmarshal(post.DownloadData, &img)
			if err != nil {
				log.Warn().Err(err).Msg("failed to unmarshal gallery")
				break
			}

			sd := title
			fmt.Println(sd)

			var galRes []string
			for _, g := range img.ImgList {
				galRes = append(galRes, h.srv.EncodeFileLink(g.Path))
			}
			resItem.Gallery = galRes
		case reddit.Image, reddit.Video:
			var img downloader.Image

			sd := title
			fmt.Println(sd)

			err = json.Unmarshal(post.DownloadData, &img)
			if err != nil {
				log.Warn().Err(err).Msg("failed to unmarshal image")
				continue
			}
			resItem.DirectLink = h.srv.EncodeFileLink(img.Path)
		}

		resItem.RedditId = post.RedditId

		result = append(result, &resItem)
	}

	return connect.NewResponse(&v1.ListDownloadedResponse{Posts: result}), nil
}
