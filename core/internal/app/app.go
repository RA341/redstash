package app

import (
	"net/http"

	rmrpc "github.com/RA341/redstash/generated/reddit/v1/v1connect"
	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/internal/database"
	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/reddit"

	"github.com/rs/zerolog/log"
	"gorm.io/gorm"
)

type App struct {
	Config *config.AppConfig
	DB     *gorm.DB
}

func SetupApp(conf *config.AppConfig, mux *http.ServeMux) (*App, error) {
	db := database.NewDB(conf.ConfigDir)
	managerStore := reddit.NewGormCredentialStore(db)
	postStore := reddit.NewGormPostStore(db)

	// services
	redditManager := reddit.NewManagerService(managerStore, postStore)
	downloaderService := downloader.NewService(
		"downloads",
		postStore,
		postStore.Save,
	)
	downloaderService.TriggerDownloader()

	// api

	//authInterceptor := connect.WithInterceptors()
	//if a.Config.Auth.Enable {
	//	//authInterceptor = connect.WithInterceptors(auth.NewInterceptor(a.Auth))
	//}

	handlers := []func() (string, http.Handler){
		func() (string, http.Handler) {
			return rmrpc.NewRedditServiceHandler(reddit.NewHandler(redditManager))
		},
	}
	for _, hand := range handlers {
		path, handler := hand()
		mux.Handle(path, handler)
	}

	log.Info().Msg("Redstash initialized successfully")
	return &App{
		Config: conf,
		DB:     db,
	}, nil
}
