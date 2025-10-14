package app

import (
	"fmt"
	"net/http"

	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/internal/database"
	"github.com/rs/zerolog/log"
)

type App struct {
	Config *config.AppConfig
	DB     *database.Service
}

func NewApp(conf *config.AppConfig) (*App, error) {
	dbSrv := database.NewService(conf.ConfigDir)

	log.Info().Msg("Redstash initialized successfully")
	return &App{
		Config: conf,
		DB:     dbSrv,
	}, nil
}

func (a *App) Close() error {
	if err := a.DB.Close(); err != nil {
		return fmt.Errorf("failed to close database service: %w", err)
	}

	return nil
}

func (a *App) registerApiRoutes(mux *http.ServeMux) {
	//authInterceptor := connect.WithInterceptors()
	//if a.Config.Auth.Enable {
	//	//authInterceptor = connect.WithInterceptors(auth.NewInterceptor(a.Auth))
	//}

	handlers := []func() (string, http.Handler){}
	for _, hand := range handlers {
		path, handler := hand()
		mux.Handle(path, handler)
	}
}
