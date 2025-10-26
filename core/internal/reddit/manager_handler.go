package reddit

import (
	"context"
	"fmt"

	"connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/reddit/v1"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) *Handler {
	return &Handler{srv: srv}
}

func (h Handler) Test(ctx context.Context, req *connect.Request[v1.TestRequest]) (*connect.Response[v1.TestResponse], error) {
	return nil, fmt.Errorf("implement me Test")
}
