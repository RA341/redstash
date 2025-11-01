package auth

import "gorm.io/gorm"

type User struct {
	gorm.Model

	Username string `gorm:"uniqueIndex;not null"`
	Password string `gorm:"index;not null"`
}

type Sessions struct {
	gorm.Model

	Token  string `gorm:"uniqueIndex;not null"`
	UserID uint   `gorm:"index;constraint:OnUpdate:CASCADE;OnDelete:CASCADE;"`
	User   User
}

type Store interface {
	CreateUser(username string, password string) error
	UpdateUser(user *User) error

	GetUser(username string) (User, error)
	CheckToken(token string) (string, error)

	DeleteUser(username string) error
}
