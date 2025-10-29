package config

import (
	"io/fs"
	"strings"
	"time"
)

type AppConfig struct {
	Port           int    `config:"flag=port,env=PORT,default=8558,usage=Port to run the server on"`
	AllowedOrigins string `config:"flag=origins,env=ORIGINS,default=*,usage=Allowed origins for the API (in CSV)"`
	UIPath         string `config:"flag=ui,env=UI_PATH,default=dist,usage=Path to frontend files"`
	ConfigDir      string `config:"flag=conf,env=CONFIG,default=/config,usage=Directory to store redstash config"`

	Downloader Downloader `config:""`
	Reddit     Reddit     `config:""`

	Log  Logger `config:""`
	UIFS fs.FS  // UIFS has no 'config' tag, so it will be ignored
}

func (c *AppConfig) GetAllowedOrigins() []string {
	elems := strings.Split(c.AllowedOrigins, ",")
	for i := range elems {
		elems[i] = strings.TrimSpace(elems[i])
	}
	return elems
}

type FilePerms struct {
	PUID int `config:"flag=puid,env=PUID,default=0,usage=PUID for composeRoot"`
	GID  int `config:"flag=gid,env=GID,default=0,usage=GID for composeRoot"`
}

type Auth struct {
	Enable       bool   `config:"flag=auth,env=AUTH_ENABLE,default=false,usage=Enable authentication"`
	Username     string `config:"flag=au,env=AUTH_USERNAME,default=admin,usage=authentication username"`
	Password     string `config:"flag=ap,env=AUTH_PASSWORD,default=admin99988,usage=authentication password,hide=true"`
	CookieExpiry string `config:"flag=ae,env=AUTH_EXPIRY,default=6h,usage=Set cookie expiry-300ms/1.5h/2h45m [ns|us|ms|s|m|h]"`
}

func (d Auth) GetCookieExpiryLimit() (time.Duration, error) {
	return time.ParseDuration(d.CookieExpiry)
}

type Reddit struct {
	CheckInterval string `config:"flag=redditCheck,env=REDDIT_POST_CHECK,default=15m,usage=Time to check for new saved posts"`
}

type Downloader struct {
	CheckInterval          string `config:"flag=downCheck,env=DOWNLOADER_CHECK,default=24h,usage=Time to trigger the downloader"`
	MaxConcurrentDownloads int    `config:"flag=maxDownloads,env=MAX_CONCURRENT_DOWNLOADS,default=20,usage=Maximum concurrent download jobs"`
	MaxQueueSize           int    `config:"flag=maxQueueSize,env=MAX_QUEUE_SIZE,default=50,usage=Maximum number of posts in queue"`
	DownloadDir            string `config:"flag=down,env=DOWNLOAD_DIR,default=downloads,usage=Directory to store downloads"`
}

type Logger struct {
	Level   string `config:"flag=logLevel,env=LOG_LEVEL,default=info,usage=disabled|debug|info|warn|error|fatal"`
	Verbose bool   `config:"flag=logVerbose,env=LOG_VERBOSE,default=false,usage=show more info in logs"`
}

func GetDurationOrDefault(defaultTime time.Duration, value string) time.Duration {
	duration, err := time.ParseDuration(value)
	if err != nil {
		return defaultTime
	}
	return duration
}
