package reddit

import "gorm.io/gorm"

type Credential struct {
	*gorm.Model
	ConfigDir    string
	ClientID     string
	ClientSecret string
	Username     string `gorm:"unique"`
	Password     string

	PostBefore string
	PostAfter  string
}

type CredentialStore interface {
	Get(id uint) (*Credential, error)
	New(cred *Credential) error
	Edit(cred *Credential) error
	Delete(id uint) error
	List() ([]Credential, error)

	PostLimitStore
}

type PostLimitStore interface {
	updateAfter(after, username string) error
	updateBefore(before, username string) error
	getPostLimit(username string) (before, after string, err error)
}
