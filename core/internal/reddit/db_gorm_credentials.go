package reddit

import (
	"errors"
	"fmt"
	"strconv"

	"gorm.io/gorm"
)

type GormCredentialStore struct {
	db *gorm.DB
}

func NewGormCredentialStore(db *gorm.DB) *GormCredentialStore {
	return &GormCredentialStore{db: db}
}

func (g *GormCredentialStore) getPostLimit(username string) (before, after string, err error) {
	var model Credential
	err = g.db.Model(&Credential{}).
		Where("username = ?", username).
		Find(&model).
		Error

	return model.PostBefore, model.PostAfter, err
}

func (g *GormCredentialStore) updateAfter(after, username string) error {
	query := g.db.Model(&Credential{}).
		Where("username = ?", username).
		Update("post_after", after)

	return query.Error
}

func (g *GormCredentialStore) updateBefore(before, username string) error {
	query := g.db.Model(&Credential{}).
		Where("username = ?", username).
		Update("post_before", before)

	return query.Error
}

func (g *GormCredentialStore) List() ([]Credential, error) {
	var credentials []Credential
	result := g.db.Model(&Credential{}).Find(&credentials)
	if result.Error != nil {
		return nil, fmt.Errorf("failed to list credentials: %w", result.Error)
	}
	return credentials, nil
}

func (g *GormCredentialStore) Get(id uint) (*Credential, error) {
	var credential Credential
	result := g.db.First(&credential, id)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, fmt.Errorf("credential not found")
		}
		return nil, fmt.Errorf("failed to get credential: %w", result.Error)
	}
	return &credential, nil
}

func (g *GormCredentialStore) New(cred *Credential) error {
	return g.db.Save(cred).Error
}

func (g *GormCredentialStore) Edit(cred *Credential) error {
	result := g.db.Save(cred)
	if result.Error != nil {
		return fmt.Errorf("failed to update credential: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("credential not found")
	}
	return nil
}

func (g *GormCredentialStore) Delete(id uint) error {
	result := g.db.Unscoped().Delete(&Credential{}, strconv.Itoa(int(id)))
	if result.Error != nil {
		return fmt.Errorf("failed to delete credential: %w", result.Error)
	}

	if result.RowsAffected == 0 {
		return fmt.Errorf("credential not found")
	}

	return nil
}
