package reddit

import (
	"context"

	"connectrpc.com/connect"
	v1 "github.com/RA341/redstash/generated/reddit/v1"
)

type Handler struct {
	srv *ManagerService
}

func NewHandler(srv *ManagerService) *Handler {
	return &Handler{srv: srv}
}

func (h *Handler) AddAccount(_ context.Context, req *connect.Request[v1.AddAccountRequest]) (*connect.Response[v1.AddAccountResponse], error) {
	cred := CredFromRPC(req.Msg)
	err := h.srv.Create(&cred)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.AddAccountResponse{}), nil
}

func (h *Handler) DeleteAccount(_ context.Context, req *connect.Request[v1.DeleteAccountRequest]) (*connect.Response[v1.DeleteAccountResponse], error) {
	id := req.Msg.AccountId
	err := h.srv.Delete(uint(id))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.DeleteAccountResponse{}), nil
}

func (h *Handler) ListAccount(context.Context, *connect.Request[v1.ListAccountRequest]) (*connect.Response[v1.ListAccountResponse], error) {
	list, err := h.srv.List()
	if err != nil {
		return nil, err
	}

	var ls []*v1.FullCredentials
	for _, item := range list {
		ls = append(ls, &v1.FullCredentials{
			AccountID: uint32(item.ID),
			Account: &v1.AccountDetails{
				ClientID:     item.ClientID,
				ClientSecret: item.ClientSecret,
				Username:     item.Username,
				Password:     item.Password,
			},
			PostBefore: item.PostBefore,
			PostAfter:  item.PostAfter,
		})
	}

	return connect.NewResponse(&v1.ListAccountResponse{Cred: ls}), nil
}

func (h *Handler) SyncPosts(context.Context, *connect.Request[v1.RunTaskRequest]) (*connect.Response[v1.RunTaskResponse], error) {
	h.srv.TriggerPostCollector()
	return connect.NewResponse(&v1.RunTaskResponse{}), nil
}

func CredFromRPC(msg *v1.AddAccountRequest) Credential {
	details := msg.Details
	return Credential{
		ClientID:     details.ClientID,
		ClientSecret: details.ClientSecret,
		Username:     details.Username,
		Password:     details.Password,
	}
}
