package reddit

import (
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type GormPostStore struct {
	db *gorm.DB
}

func (g *GormPostStore) ListAll() ([]Post, error) {
	var posts []Post
	tx := g.db.Find(&posts)
	return posts, tx.Error
}

func NewGormPostStore(db *gorm.DB) PostStore {
	return &GormPostStore{db: db}
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

func (g *GormPostStore) List(offset, limit int) ([]Post, error) {
	var posts []Post
	tx := g.db.Offset(offset).Limit(limit).Find(&posts)

	return posts, tx.Error
}
