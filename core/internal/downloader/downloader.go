package downloader

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"time"

	"github.com/RA341/redstash/internal/reddit"
	"github.com/RA341/redstash/pkg/fileutil"
)

func downloadGallery(post *reddit.Post, downloadDir string) error {
	data, err := getMap(post)
	if err != nil {
		return err
	}

	imgMap := data["media_metadata"].(map[string]interface{})

	var imgList Gallery

	for _, i := range imgMap {
		downloadLink := i.(map[string]interface{})["s"].(map[string]interface{})["u"].(string)
		filename, err := downloadMediaLink(downloadLink, downloadDir)
		if err != nil {
			return err
		}
		imgList.ImgList = append(imgList.ImgList, Image{filename})
	}

	marshal, err := json.Marshal(imgList)
	if err != nil {
		return err
	}
	post.DownloadData = marshal

	return nil
}

func downloadImage(post *reddit.Post, downloadDir string) error {
	data, err := getMap(post)
	if err != nil {
		return err
	}
	imgUrl, ok := data["url"]
	if !ok {
		return fmt.Errorf("key 'url' not found in post to download image")
	}
	imageUrl := imgUrl.(string)

	filename, err := downloadMediaLink(imageUrl, downloadDir)
	if err != nil {
		return err
	}

	img := Image{Path: filename}
	marshal, err := json.Marshal(img)
	if err != nil {
		return err
	}
	post.DownloadData = marshal

	return nil
}

func downloadVideo(post *reddit.Post, downloadDir string, downloader *RedgifsClient) error {
	data, err := getMap(post)
	if err != nil {
		return err
	}

	//https://www.redgifs.com/watch/
	imgUrl, ok := data["url"]
	if !ok {
		return fmt.Errorf("key 'url' not found in post to download image")
	}
	imageUrl := imgUrl.(string)

	link, err := downloader.GetDownloadLink(imageUrl, false)
	if err != nil {
		return err
	}

	fromLink, err := downloadMediaLink(link, downloadDir)
	if err != nil {
		return err
	}

	img := Image{Path: fromLink}
	marshal, err := json.Marshal(img)
	if err != nil {
		return err
	}
	post.DownloadData = marshal

	return nil
}

var mediaHttpClient = &http.Client{
	Timeout: 5 * time.Minute,
	Transport: &http.Transport{
		MaxIdleConns:        100,
		MaxIdleConnsPerHost: 50,
		IdleConnTimeout:     90 * time.Second,
	},
}

// Use standard http.Client for streaming
// resty causes mem issues, or I am using it wrong
func downloadMediaLink(imageUrl string, downloadDir string) (string, error) {
	resp, err := mediaHttpClient.Get(imageUrl)
	if err != nil {
		return "", fmt.Errorf("failed to download image: %w", err)
	}
	defer fileutil.Close(resp.Body)

	if resp.StatusCode >= 400 {
		return "", fmt.Errorf("failed to download image: status %d", resp.StatusCode)
	}

	parsedURL, err := url.Parse(imageUrl)
	if err != nil {
		return "", fmt.Errorf("failed to parse URL: %w", err)
	}
	base := filepath.Base(parsedURL.Path)

	filename := filepath.Join(downloadDir, base)
	file, err := os.Create(filename)
	if err != nil {
		return "", fmt.Errorf("failed to open output file %s: %w", filename, err)
	}
	defer fileutil.Close(file)

	// Stream directly from response body to file
	_, err = io.Copy(file, resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to write to output file %s: %w", filename, err)
	}

	return filename, nil
}

func getMap(post *reddit.Post) (map[string]interface{}, error) {
	var data map[string]interface{}
	err := json.Unmarshal(post.Data, &data)
	if err != nil {
		return nil, fmt.Errorf("error unmarshalling post data: %w", err)
	}
	return data, nil
}
