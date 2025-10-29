package downloader

import "github.com/RA341/redstash/internal/reddit"

type Image struct {
	Path string `json:"path"`
}

type Downloader func(post *reddit.Post, downloadDir string) error

type Gallery struct {
	ImgList []Image `json:"images"`
}
