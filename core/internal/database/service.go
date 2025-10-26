package database

import (
	"os"
	"path/filepath"

	"github.com/RA341/redstash/internal/reddit"
	"github.com/rs/zerolog/log"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

const dbFileName = "redstash.db"

func connect(dbpath string) (*gorm.DB, error) {
	// Configure SQLite to use WAL mode
	connectionStr := dbpath + "?_journal_mode=WAL&_busy_timeout=5000"
	conn := sqlite.Open(connectionStr)
	conf := &gorm.Config{
		Logger:      logger.Default.LogMode(logger.Silent),
		PrepareStmt: true,
	}
	//conf = &gorm.Config{
	//	//Logger:      logger.Default.LogMode(logger.Info),
	//	PrepareStmt: true,
	//}

	db, err := gorm.Open(conn, conf)
	if err != nil {
		return nil, err
	}

	log.Info().Str("path", dbpath).Msg("Connected to database")
	return db, nil
}

func NewDB(basepath string) *gorm.DB {
	err := os.MkdirAll(basepath, os.ModePerm)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to create database directory")
	}

	basepath = filepath.Join(basepath, dbFileName)
	dbpath, err := filepath.Abs(basepath)
	if err != nil {
		log.Fatal().Err(err).
			Str("basepath", basepath).
			Msg("unable to get abs path for db")
	}

	gormDB, err := connect(dbpath)
	if err != nil {
		log.Fatal().Err(err).Msg("Unable to connect to database")
	}

	tables := []interface{}{
		&reddit.Post{},
		&reddit.Credential{},
	}
	if err = gormDB.AutoMigrate(tables...); err != nil {
		log.Fatal().Err(err).Msg("failed to auto migrate DB")
	}

	return gormDB
}
