package reddit

import (
	"time"

	"github.com/RA341/redstash/pkg/schd"
	"github.com/rs/zerolog/log"
)

type ClientService struct {
	scd *schd.Scheduler
	cli *ApiClient
}

func NewClientService(
	cred *Credential,
	limitStore PostLimitStore,
	postStore PostStore,
	triggerDownload func(),
) *ClientService {
	cli := NewApiClient(cred, limitStore, postStore, triggerDownload)
	scd := schd.NewScheduler(
		func() {
			err := cli.GetAllSavedPosts()
			if err != nil {
				log.Warn().Msg("error occurred while getting saved posts")
			}
		},
		6*time.Hour,
	)

	return &ClientService{
		cli: cli,
		scd: scd,
	}
}

func (s *ClientService) Trigger() {
	s.scd.Manual()
}

func (s *ClientService) Start() {
	s.scd.Start()
}

func (s *ClientService) Stop() {
	s.scd.Stop()
}
