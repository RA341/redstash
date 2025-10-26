package reddit

import (
	"time"

	"github.com/RA341/redstash/pkg/schd"
	"github.com/rs/zerolog/log"
)

type Service struct {
	scd *schd.Scheduler
	cli *ApiClient
}

func NewService(cred *Credential, limitStore PostLimitStore, postStore PostStore) *Service {
	cli := NewApiClient(cred, limitStore, postStore)
	scd := schd.NewScheduler(
		func() {
			err := cli.GetAllSavedPosts()
			if err != nil {
				log.Warn().Msg("error occurred while getting saved posts")
			}
		},
		6*time.Hour,
	)

	return &Service{
		cli: cli,
		scd: scd,
	}
}

func (s *Service) Trigger() {
	s.scd.Manual()
}

func (s *Service) Start() {
	s.scd.Start()
}

func (s *Service) Stop() {
	s.scd.Stop()
}
