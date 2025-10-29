package reddit

import (
	"time"

	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/pkg/schd"
	"github.com/rs/zerolog/log"
)

type ClientService struct {
	task *schd.Scheduler
	cli  *ApiClient
}

func NewClientService(conf ConfigProvider, cred *Credential, limitStore PostLimitStore, postStore PostStore, triggerDownload func()) *ClientService {
	cli := NewApiClient(
		cred,
		limitStore,
		postStore,
		triggerDownload,
	)

	// todo get from config
	interval := config.GetDurationOrDefault(15*time.Minute, conf().CheckInterval)
	scd := schd.NewScheduler(
		func() {
			err := cli.GetAllSavedPosts()
			if err != nil {
				log.Warn().Msg("error occurred while getting saved posts")
			}
		},
		interval,
	)

	return &ClientService{
		cli:  cli,
		task: scd,
	}
}
