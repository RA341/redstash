package reddit

import (
	"fmt"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type GormPostStore struct {
	db *gorm.DB
}

func NewGormPostStore(db *gorm.DB) *GormPostStore {
	return &GormPostStore{db: db}
}

func (g *GormPostStore) UpdateMetadata(post *Post) error {
	if post.ID == 0 {
		return fmt.Errorf("post id is zero")
	}
	return g.db.Save(post).Error
}

func (g *GormPostStore) ListNonTaggedPosts(limit int, posts []Post) ([]Post, error) {
	tx := g.db.
		Limit(limit).
		Where("media_metadata_tagged = ?", false).
		Where("download_data IS NOT NULL OR download_data != ?", "").
		Where("media_type != ?", "unknown").
		Find(&posts)
	return posts, tx.Error

}

func (g *GormPostStore) SetAllToUntagged() error {
	return g.db.
		Where("media_metadata_tagged = ?", true).
		Update("media_metadata_tagged", false).Error
}

func (g *GormPostStore) ListDownloaded(offset, limit int, result *[]Post, accountID int) error {
	return g.loadPostsByRedditCreatedUpdated(offset, limit, accountID).
		Where("download_data IS NOT NULL OR download_data != ?", "").
		Find(result).Error
}

func (g *GormPostStore) ListError(offset, limit int, result *[]Post, accountID int) error {
	return g.loadPostsByRedditCreatedUpdated(offset, limit, accountID).
		Where("error_data IS NOT NULL OR error_data != ?", "").
		Find(result).Error
}

func (g *GormPostStore) loadPostsByRedditCreatedUpdated(offset int, limit int, accountID int) *gorm.DB {
	return g.db.
		Order("created_reddit desc").
		Limit(limit).Offset(offset).
		Where("user_credential_id = ?", accountID)
}

func (g *GormPostStore) ListNonDownloaded(limit int, result *[]Post) error {
	tx := g.db.
		Limit(limit).
		Where("download_data IS NULL OR download_data = ?", "").
		Where("error_data IS NULL OR error_data = ?", "").
		Where("media_type != ?", Unsupported).
		Find(result)

	return tx.Error
}

func (g *GormPostStore) ClearDownloadData() error {
	return g.db.Model(&Post{}).
		Where("1 = 1"). // update all rows
		Updates(map[string]interface{}{
			"download_data": nil,
			"error_data":    nil,
		}).
		Error
}

func (g *GormPostStore) SaveAll(posts []Post) error {
	result := g.db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "reddit_id"}},
		UpdateAll: true, // updates all columns
	}).Create(&posts)

	return result.Error
}

func (g *GormPostStore) Save(post *Post) error {
	return g.db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "reddit_id"}},
		UpdateAll: true, // updates all columns
	}).Create(post).Error
}
