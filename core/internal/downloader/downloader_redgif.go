package downloader

import (
	"fmt"
	"net/url"
	"path"
	"strings"
	"time"

	"github.com/RA341/redstash/internal/reddit"
	"resty.dev/v3"
)

type RedgifsClient struct {
	client *resty.Client
	token  string
}

func NewClient() *RedgifsClient {
	rc := resty.New()
	rc.SetTimeout(15 * time.Second)
	rc.SetHeader("User-Agent", reddit.UserAgent)
	rc.SetHeader("Accept", "application/json")
	return &RedgifsClient{client: rc}
}

// Login obtains a temporary token from https://api.redgifs.com/v2/auth/temporary and stores it.
// After Login succeeds, Authorization: Bearer <token> is automatically set for subsequent requests.
func (c *RedgifsClient) Login() error {
	type tokenResp struct {
		Token string `json:"token"`
	}

	resp, err := c.client.R().
		SetResult(&tokenResp{}).
		Get("https://api.redgifs.com/v2/auth/temporary")
	if err != nil {
		return fmt.Errorf("request failed: %w", err)
	}

	if resp.IsError() {
		return fmt.Errorf("token endpoint returned status %d", resp.StatusCode())
	}

	tr := resp.Result().(*tokenResp)
	if tr == nil || tr.Token == "" {
		return fmt.Errorf("no token in response")
	}
	c.token = tr.Token
	// resty convenience: set auth token on client for all future requests
	c.client.SetAuthToken(c.token)
	return nil
}

type RedGifResponse struct {
	Gif struct {
		URLs struct {
			HD *string `json:"hd"`
			SD string  `json:"sd"`
		} `json:"urls"`
	} `json:"gif"`
}

// GetDownloadLink resolves a redgifs "watch" URL or raw id to a direct media URL.
//   - watchOrID: either a full watch URL (https://www.redgifs.com/watch/ID) or just the ID string.
//   - preferFileURL: if true, build and return the "file" API mp4 URL derived from the sd url
//     If false, prefer hd (if present) else sd.
func (c *RedgifsClient) GetDownloadLink(watchOrID string, preferFileURL bool) (string, error) {
	id, err := extractID(watchOrID)
	if err != nil {
		return "", err
	}

	apiURL := fmt.Sprintf("https://api.redgifs.com/v2/gifs/%s", id)

	var apiResp RedGifResponse

	resp, err := c.client.R().
		SetResult(&apiResp).
		Get(apiURL)
	if err != nil {
		return "", fmt.Errorf("api request failed: %w", err)
	}

	if resp.StatusCode() == 404 {
		return "", fmt.Errorf("gif not found (404)")
	}
	if resp.IsError() {
		// try to include small body for debugging
		body := resp.String()
		return "", fmt.Errorf("api returned status %d: %s", resp.StatusCode(), body)
	}

	r := resp.Result().(*RedGifResponse)
	// choose according to preferFileURL and availability
	if preferFileURL {
		// need SD (pref) otherwise fallback to HD to construct "file" url
		mediaURL := r.Gif.URLs.SD
		if mediaURL == "" && r.Gif.URLs.HD != nil {
			mediaURL = *r.Gif.URLs.HD
		}
		if mediaURL == "" {
			return "", fmt.Errorf("no sd/hd url available to construct file url")
		}
		return buildFileURL(mediaURL), nil
	}

	// prefer hd if present, otherwise sd
	if r.Gif.URLs.HD != nil && *r.Gif.URLs.HD != "" {
		return *r.Gif.URLs.HD, nil
	}
	if r.Gif.URLs.SD != "" {
		return r.Gif.URLs.SD, nil
	}
	return "", fmt.Errorf("no downloadable url found in api response")
}

// extractID accepts either a watch URL or raw id and returns the id.
func extractID(watchOrID string) (string, error) {
	in := strings.TrimSpace(watchOrID)
	if in == "" {
		return "", fmt.Errorf("empty input")
	}
	u, err := url.Parse(in)
	if err == nil && u.Host != "" {
		// It's a URL
		if !strings.Contains(u.Host, "redgifs.com") {
			return "", fmt.Errorf("not a redgifs url")
		}
		seg := path.Base(u.Path)
		// Path could be "watch" or "watch/" or the id
		if seg == "" || seg == "watch" || seg == "/" {
			return "", fmt.Errorf("could not extract gif id from url")
		}
		return seg, nil
	}
	// otherwise assume it's an id already
	return in, nil
}

// buildFileURL mirrors the Python build_file_url behavior:
// - take the media URL path, remove slashes and "-mobile.mp4" suffix to form filename
// - folder uses lowercase filename, file name is original filename + .mp4
// returns: https://api.redgifs.com/v2/gifs/{filenameLower}/files/{filename}.mp4
func buildFileURL(mediaURL string) string {
	u, err := url.Parse(mediaURL)
	if err != nil {
		// fallback to mediaURL if parsing fails
		return mediaURL
	}
	// remove leading slashes from path and get last segment
	seg := path.Base(u.Path) // e.g. "preciousvigilantnorwaylobster-mobile.mp4" or "preciousvigilantnorwaylobster.mp4"
	// remove -mobile.mp4 or .mp4 to get base filename
	name := strings.TrimSuffix(seg, "-mobile.mp4")
	name = strings.TrimSuffix(name, ".mp4")
	if name == "" {
		// fallback use seg without extension
		name = strings.TrimSuffix(seg, path.Ext(seg))
	}
	filenameLower := strings.ToLower(name)
	// The Python code used the (possibly camelcase) name in the final file name and lowercase folder.
	// We'll follow that.
	return fmt.Sprintf("https://api.redgifs.com/v2/gifs/%s/files/%s.mp4", filenameLower, name)
}
