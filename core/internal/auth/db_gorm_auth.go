package auth

import "gorm.io/gorm"

type GormAuthDB struct {
	db *gorm.DB
}

func (g *GormAuthDB) CreateUser(username string, password string) error {
	return g.db.Save(&User{
		Username: username,
		Password: password,
	}).Error
}

func (g *GormAuthDB) UpdateUser(user *User) error {
	return g.db.Save(user).Error
}

func (g *GormAuthDB) GetUser(username string) (User, error) {
	//TODO implement me
	panic("implement me")
}

func (g *GormAuthDB) CheckToken(token string) (string, error) {
	//TODO implement me
	panic("implement me")
}

func (g *GormAuthDB) DeleteUser(username string) error {
	//TODO implement me
	panic("implement me")
}

func NewGormAuthDB(db *gorm.DB) *GormAuthDB {
	return &GormAuthDB{db: db}
}
