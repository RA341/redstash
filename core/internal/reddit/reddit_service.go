package reddit

import (
	"time"

	"github.com/RA341/redstash/pkg/schd"
	"github.com/rs/zerolog/log"
)

type ClientService struct {
	task *schd.Scheduler
	cli  *ApiClient
}

func NewClientService(
	cred *Credential,
	limitStore PostLimitStore,
	postStore PostStore,
	triggerDownload func(),
) *ClientService {
	cli := NewApiClient(
		cred,
		limitStore,
		postStore,
		triggerDownload,
	)

	// todo get from config
	checkInterval := 1 * time.Hour
	scd := schd.NewScheduler(
		func() {
			err := cli.GetAllSavedPosts()
			if err != nil {
				log.Warn().Msg("error occurred while getting saved posts")
			}
		},
		checkInterval,
	)

	return &ClientService{
		cli:  cli,
		task: scd,
	}
}
