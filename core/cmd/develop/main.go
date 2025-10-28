package main

import (
	"log"
	"net/http"
	"os"

	_ "net/http/pprof"

	"github.com/RA341/redstash/internal/app"
	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/pkg/argos"
)

// useful for developing sets some default options
func main() {
	go func() {
		log.Println(http.ListenAndServe("localhost:6060", nil))
	}()

	prefixer := argos.Prefixer(config.EnvPrefix)

	envMap := map[string]string{
		//"AUTH_ENABLE":   "true",
		"AUTH_USERNAME": "test",
		"AUTH_PASSWORD": "test",
		"LOG_LEVEL":     "debug",
		"LOG_VERBOSE":   "true",
		"CONFIG":        "./config",
		"COMPOSE_ROOT":  "./compose",
		"UPDATER_HOST":  "http://localhost:8869",
	}

	for k, v := range envMap {
		_ = os.Setenv(prefixer(k), v)
	}

	app.StartServer()
}
