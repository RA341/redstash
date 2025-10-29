package app

import (
	"fmt"
	"net/http"
	"strings"

	downrpc "github.com/RA341/redstash/generated/downloader/v1/v1connect"
	postsrpc "github.com/RA341/redstash/generated/posts/v1/v1connect"
	rmrpc "github.com/RA341/redstash/generated/reddit/v1/v1connect"
	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/internal/database"
	"github.com/RA341/redstash/internal/downloader"
	"github.com/RA341/redstash/internal/info"
	"github.com/RA341/redstash/internal/posts"
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

	if info.IsDev() {
		log.Info().Msg("Dev Mode clearing downLOAD data")
		err := postStore.ClearDownloadData()
		if err != nil {
			return nil, fmt.Errorf("error clearing download data: %w", err)
		}

	}

	// services
	downloaderService := downloader.NewService(
		conf.DownloadDir,
		postStore,
		postStore.Save,
	)

	redditManager := reddit.NewManagerService(
		managerStore,
		postStore,
		downloaderService.Task.Manual,
	)
	postSrv := posts.NewService(postStore, conf.DownloadDir)

	// start any previous incomplete downloads
	downloaderService.Task.Manual()

	// api
	//authInterceptor := connect.WithInterceptors()
	//if a.Config.Auth.Enable {
	//	//authInterceptor = connect.WithInterceptors(auth.NewInterceptor(a.Auth))
	//}

	handlers := []func() (string, http.Handler){
		func() (string, http.Handler) {
			return rmrpc.NewRedditServiceHandler(reddit.NewHandler(redditManager))
		},
		func() (string, http.Handler) {
			return postsrpc.NewPostsServiceHandler(posts.NewHandler(postSrv))
		},
		func() (string, http.Handler) {
			return registerHttpHandler("/api/posts", posts.NewHandlerHttp(postSrv))
		},
		func() (string, http.Handler) {
			return downrpc.NewDownloaderServiceHandler(downloader.NewHandler(downloaderService))
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

func registerHttpHandler(basePath string, subMux http.Handler) (string, http.Handler) {
	if !strings.HasSuffix(basePath, "/") {
		basePath = basePath + "/"
	}

	baseHandler := http.StripPrefix(strings.TrimSuffix(basePath, "/"), subMux)
	// todo
	//if a.Config.Auth.Enable {
	//	httpAuth := auth.NewHttpAuthMiddleware(a.Auth)
	//	baseHandler = httpAuth(baseHandler)
	//}

	return basePath, baseHandler
}
