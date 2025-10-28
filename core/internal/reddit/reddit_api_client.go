package reddit

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/RA341/redstash/internal/info"
	"github.com/rs/zerolog/log"
	"resty.dev/v3"
)

var UserAgent = fmt.Sprintf("redstash:%s (by /u/descendent-of-apes)", info.Version)

// TokenResponse struct to parse the response
type TokenResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
	Scope       string `json:"scope"`
}

type ApiClient struct {
	maxPostsToFetch int

	cred *Credential

	auth    *TokenResponse
	expires time.Time
	client  *resty.Client

	postStore PostStore
	credStore PostLimitStore

	startDownloader func()
}

func NewApiClient(
	cred *Credential,
	credStore PostLimitStore,
	postStore PostStore,
	startDownloader func(),
) *ApiClient {
	client := resty.New()
	client.SetHeader("User-Agent", UserAgent)

	return &ApiClient{
		maxPostsToFetch: 100,
		cred:            cred,

		client: client,

		postStore: postStore,
		credStore: credStore,

		startDownloader: startDownloader,
	}
}

func CheckCredentials(cred *Credential, credStore CredentialStore) error {
	cli := NewApiClient(cred, credStore, nil, nil)
	return cli.Login()
}

func (s *ApiClient) Login() error {
	if s.auth != nil && time.Now().Before(s.expires) {
		log.Info().Msg("token is not expired")
		return nil
	}

	formData := map[string]string{
		"grant_type": "password",
		"username":   s.cred.Username,
		"password":   s.cred.Password,
	}

	resp, err := s.client.R().
		SetBasicAuth(s.cred.ClientID, s.cred.ClientSecret).
		SetFormData(formData).
		SetResult(&TokenResponse{}). // automatically unmarshal to struct
		Post("https://www.reddit.com/api/v1/access_token")

	if err != nil {
		return fmt.Errorf("failed to make request: %w", err)
	}

	if resp.StatusCode() != 200 {
		return fmt.Errorf("login failed with status %d: %s", resp.StatusCode(), resp.String())
	}

	token, ok := resp.Result().(*TokenResponse)
	if !ok {
		return fmt.Errorf("unable to assert response to struct, response: %v", resp.Result())
	}
	s.auth = token
	s.expires = time.Now().Add(time.Duration(token.ExpiresIn) * time.Second)

	return nil
}

func (s *ApiClient) GetAllSavedPosts() error {
	if err := s.Login(); err != nil {
		return err
	}

	err := s.getAllSavedWithAfter()
	if err != nil {
		return err
	}

	err = s.getAllSavedWithBefore()
	if err != nil {
		return err
	}

	s.startDownloader()
	return nil
}

func (s *ApiClient) getAllSavedWithBefore() error {
	return s.getAllSavedPosts(
		func() (*SavedResponse, error) {
			before, _, err := s.credStore.getPostLimit(s.cred.Username)
			if err != nil {
				return nil, err
			}

			result, err := s.getSavedPosts("", before)
			if err != nil {
				return nil, err
			}

			return result, nil
		}, func(posts []Post) error {
			err := s.postStore.SaveAll(posts)
			if err != nil {
				return err
			}

			firstPost := posts[0]
			err = s.credStore.updateBefore(firstPost.RedditId, s.cred.Username)
			if err != nil {
				return err
			}

			return nil
		},
	)
}

func (s *ApiClient) getAllSavedWithAfter() error {
	err := s.getAllSavedPosts(
		func() (*SavedResponse, error) {
			_, after, err := s.credStore.getPostLimit(s.cred.Username)
			if err != nil {
				return nil, err
			}

			result, err := s.getSavedPosts(after, "")
			if err != nil {
				return nil, err
			}
			return result, nil
		},
		func(posts []Post) error {
			err := s.postStore.SaveAll(posts)
			if err != nil {
				return err
			}

			_, after, err := s.credStore.getPostLimit(s.cred.Username)
			if err != nil {
				return err
			}

			firstItem := posts[0].RedditId
			if after == "" && firstItem != "" {
				// first post
				err = s.credStore.updateBefore(firstItem, s.cred.Username)
				if err != nil {
					return err
				}
			}

			lastIndex := len(posts) - 1
			lastPost := posts[lastIndex]
			err = s.credStore.updateAfter(lastPost.RedditId, s.cred.Username)
			if err != nil {
				return err
			}

			return nil
		},
	)
	if err != nil {
		return err
	}

	return nil
}

func (s *ApiClient) getAllSavedPosts(
	getPostFn func() (*SavedResponse, error),
	onPostNotEmptyFn func(post []Post) error,
) error {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return nil
		case <-ticker.C:
			result, err := getPostFn()
			if err != nil {
				return err
			}

			posts, err := s.savePostsToDB(result)
			if err != nil {
				return err
			}

			if len(posts) > 0 {
				err = onPostNotEmptyFn(posts)
				if err != nil {
					return err
				}
			}

			// this means that reddit returned less than what we expected
			// implying we have reached the end of list
			if result.Data.Count != s.maxPostsToFetch {
				cancel()
			}
		}
	}
}

func (s *ApiClient) savePostsToDB(result *SavedResponse) ([]Post, error) {
	var posts []Post

	for _, p := range result.Data.Children {
		var postItem Post

		err := postItem.SetData(p.Data, s.cred)
		if err != nil {
			// todo continue on error
			return nil, fmt.Errorf("failed to set post data: %w", err)
		}
		posts = append(posts, postItem)

		fmt.Println(p.Data["title"])
	}

	return posts, nil
}

func (s *ApiClient) getSavedPosts(after, before string) (*SavedResponse, error) {
	client := resty.New()
	client.SetHeader("User-Agent", UserAgent)
	var res SavedResponse

	resp, err := client.R().
		SetAuthToken(s.auth.AccessToken).
		SetQueryParams(map[string]string{
			"limit":    strconv.Itoa(s.maxPostsToFetch),
			"after":    after,
			"before":   before,
			"raw_json": "1",
		}).
		SetResult(&res).
		Get(fmt.Sprintf("https://oauth.reddit.com/user/%s/saved", s.cred.Username))

	if err != nil {
		return nil, fmt.Errorf("failed to get saved posts: %w", err)
	}

	if resp.StatusCode() != 200 {
		return nil, fmt.Errorf("request failed with status %d: %s", resp.StatusCode(), resp.String())
	}

	return &res, nil
}
