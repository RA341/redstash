package reddit

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/rs/zerolog/log"
	"gorm.io/gorm"
)

type MediaType string

const (
	Gallery     MediaType = "gallery"
	Image       MediaType = "image"
	Video       MediaType = "video"
	Unsupported MediaType = "unsupported"
)

type PostStore interface {
	Save(post *Post) error
	SaveAll(post []Post) error

	ListAll() ([]Post, error)
	ListNonDownloaded(limit int, result *[]Post) error
	ListDownloaded(offset, limit int, result *[]Post, accountID int) error
	ListError(offset, limit int, result *[]Post, accountID int) error

	UpdateVideoRatio(post *Post) error

	ClearDownloadData() error
}

type Post struct {
	*gorm.Model

	UserCredentialID uint       `gorm:"index;column:user_credential_id"`
	Credential       Credential `gorm:"foreignKey:UserCredentialID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`

	RedditId            string `gorm:"uniqueIndex"`
	MediaType           MediaType
	Data                []byte `gorm:"type:text"`
	VideoDimensionRatio float32

	PermLink      string
	Subreddit     string
	Title         string
	CreatedReddit time.Time

	DownloadData []byte `gorm:"type:text"`
	ErrorData    string `gorm:"type:text"`
}

func (p *Post) SetData(data map[string]interface{}, cred *Credential) error {
	if val, ok := data["media"]; ok && val != nil {
		p.MediaType = Video
	} else if val, ok = data["gallery_data"]; ok && val != nil {
		p.MediaType = Gallery
	} else if val, ok = data["post_hint"]; ok && val == "image" {
		p.MediaType = Image
	} else {
		p.MediaType = Unsupported
	}

	p.UserCredentialID = cred.ID

	redID, err := getMapVal[string](data, "name")
	if err != nil {
		return err
	}

	title, err := getMapVal[string](data, "title")
	if err != nil {
		return err
	}
	subreddit, err := getMapVal[string](data, "subreddit")
	if err != nil {
		log.Warn().Err(err).Msg("unable to get value")
		return err
	}

	permLink, err := getMapVal[string](data, "permalink")
	if err != nil {
		log.Warn().Err(err).Msg("unable to get value")
		return err
	}

	created, err := getMapVal[float64](data, "created")
	if err != nil {
		log.Warn().Err(err).Msg("unable to get value")
		return err
	}
	createdAt := time.Unix(int64(created), 0)

	p.RedditId = redID
	p.Title = title
	p.Subreddit = subreddit
	p.CreatedReddit = createdAt
	p.PermLink = permLink

	b, err := json.Marshal(data)
	if err != nil {
		return err
	}
	p.Data = b

	return nil
}

type SavedResponse struct {
	Data struct {
		Count    int    `json:"dist"`
		After    string `json:"after"`
		Before   string `json:"before"`
		Children []struct {
			Data map[string]interface{} `json:"data"`
		} `json:"children"`
	} `json:"data"`
}

func getMapVal[T any](data map[string]interface{}, key string) (T, error) {
	value, ok := data[key].(T)
	if !ok {
		var zero T
		return zero, fmt.Errorf("key=%s is not a str or does not exist. value=%v", key, value)
	}
	return value, nil
}
