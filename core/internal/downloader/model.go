package downloader

import "github.com/RA341/redstash/internal/reddit"

type Downloader func(post *reddit.Post, downloadDir string) error

type Image struct {
	Path  string  `json:"path"`
	Ratio float32 `json:"ratio"`
}

type Gallery struct {
	ImgList []Image `json:"images"`
}
