package downloader

import (
	"context"

	"connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/downloader/v1"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) *Handler {
	return &Handler{
		srv: srv,
	}
}

func (h *Handler) TriggerDownloader(context.Context, *connect.Request[v1.TriggerDownloaderRequest]) (*connect.Response[v1.TriggerDownloaderResponse], error) {
	h.srv.Task.Manual()
	return connect.NewResponse(&v1.TriggerDownloaderResponse{}), nil
}
