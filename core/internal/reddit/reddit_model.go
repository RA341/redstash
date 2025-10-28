package reddit

import (
	"encoding/json"
	"fmt"

	"gorm.io/gorm"
)

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
	List(offset, limit int) ([]Post, error)
	ListAll() ([]Post, error)
	ListNonDownloaded(limit int) ([]Post, error)
}

type Post struct {
	*gorm.Model

	UserCredentialID uint       `gorm:"index;column:user_credential_id"`
	Credential       Credential `gorm:"foreignKey:UserCredentialID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`

	// post id
	RedditId string `gorm:"uniqueIndex"`
	// type
	MediaType    MediaType
	DownloadData []byte `gorm:"type:text"`

	ErrorData string `gorm:"type:text"`

	// todo download table
	//download DownloadedMedia
	Data []byte `gorm:"type:text"`
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
	p.Credential = *cred

	redID, ok := data["name"].(string)
	if !ok {
		return fmt.Errorf("reddit id not found")
	}
	p.RedditId = redID

	b, err := json.Marshal(data)
	if err != nil {
		return err
	}
	p.Data = b

	return nil
}

func (p *Post) GetData(target interface{}) error {
	return json.Unmarshal(p.Data, target)
}
