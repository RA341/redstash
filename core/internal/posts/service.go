package posts

import (
	"path/filepath"
	"strings"

	"github.com/RA341/redstash/internal/reddit"
)

type Service struct {
	store        reddit.PostStore
	downloadPath string
}

func NewService(db reddit.PostStore, downloadPath string) *Service {
	s := &Service{
		store:        db,
		downloadPath: downloadPath,
	}

	return s
}

func (s *Service) EncodeFileLink(link string) string {
	return strings.TrimPrefix(
		filepath.ToSlash(
			strings.TrimPrefix(link, s.downloadPath),
		),
		"/",
	)
}

func (s *Service) DecodeFileLink(link string) string {
	return filepath.Join(s.downloadPath, link)
}

func (s *Service) ListDownloaded(offset, limit, accountID int) ([]reddit.Post, error) {
	var posts = make([]reddit.Post, 0, 100)
	err := s.store.ListDownloaded(offset, limit, &posts, accountID)
	return posts, err
}

func (s *Service) ListError(offset, limit, accountID int) ([]reddit.Post, error) {
	var posts = make([]reddit.Post, 0, 100)
	err := s.store.ListError(offset, limit, &posts, accountID)
	return posts, err
}
