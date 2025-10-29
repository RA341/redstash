package reddit

import (
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type GormPostStore struct {
	db *gorm.DB
}

func (g *GormPostStore) ListError(offset, limit int, result *[]Post, accountID int) error {
	return g.db.
		Limit(limit).Offset(offset).
		Where("user_credential_id = ?", accountID).
		Where("error_data IS NOT NULL OR error_data != ?", "").
		Find(result).Error
}

func (g *GormPostStore) ListDownloaded(offset, limit int, result *[]Post, accountID int) error {
	return g.db.
		Limit(limit).Offset(offset).
		Where("user_credential_id = ?", accountID).
		Where("download_data IS NOT NULL OR download_data != ?", "").
		Find(result).Error
}

func NewGormPostStore(db *gorm.DB) PostStore {
	return &GormPostStore{db: db}
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

func (g *GormPostStore) ListAll() ([]Post, error) {
	var posts []Post
	tx := g.db.Find(&posts)
	return posts, tx.Error
}

func (g *GormPostStore) List(offset, limit int) ([]Post, error) {
	var posts []Post
	tx := g.db.Offset(offset).Limit(limit).Find(&posts)

	return posts, tx.Error
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
