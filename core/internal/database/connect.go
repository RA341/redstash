package database

import (
	"fmt"
	"path/filepath"

	"github.com/rs/zerolog/log"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

const dockmanDB = "redstash.db"

func connect(basepath string) (*gorm.DB, error) {
	basepath = filepath.Join(basepath, dockmanDB)
	dbpath, err := filepath.Abs(basepath)
	if err != nil {
		return nil, fmt.Errorf("unable to get abs path of %s: %w", basepath, err)
	}

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
