package database

import (
	"github.com/rs/zerolog/log"
)

type Service struct{}

func NewService(basepath string) *Service {
	gormDB, err := connect(basepath)
	if err != nil {
		log.Fatal().Err(err).Msg("Unable to connect to database")
	}

	// todo make model migration with unified with impl inits
	tables := []interface{}{}
	if err = gormDB.AutoMigrate(tables...); err != nil {
		log.Fatal().Err(err).Msg("failed to auto migrate DB")
	}

	return &Service{}
}

func (s *Service) Close() error {
	return nil
}
