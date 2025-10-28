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
	DownloadDir    string `config:"flag=down,env=DOWNLOAD_DIR,default=downloads,usage=Directory to store downloads"`

	Log  Logger `config:""`
	UIFS fs.FS  // UIFS has no 'config' tag, so it will be ignored
}

type FilePerms struct {
	PUID int `config:"flag=puid,env=PUID,default=0,usage=PUID for composeRoot"`
	GID  int `config:"flag=gid,env=GID,default=0,usage=GID for composeRoot"`
}

type AuthConfig struct {
	Enable       bool   `config:"flag=auth,env=AUTH_ENABLE,default=false,usage=Enable authentication"`
	Username     string `config:"flag=au,env=AUTH_USERNAME,default=admin,usage=authentication username"`
	Password     string `config:"flag=ap,env=AUTH_PASSWORD,default=admin99988,usage=authentication password,hide=true"`
	CookieExpiry string `config:"flag=ae,env=AUTH_EXPIRY,default=6h,usage=Set cookie expiry-300ms/1.5h/2h45m [ns|us|ms|s|m|h]"`
}

func (d AuthConfig) GetCookieExpiryLimit() (time.Duration, error) {
	return time.ParseDuration(d.CookieExpiry)
}

type Logger struct {
	Level   string `config:"flag=logLevel,env=LOG_LEVEL,default=info,usage=disabled|debug|info|warn|error|fatal"`
	Verbose bool   `config:"flag=logVerbose,env=LOG_VERBOSE,default=false,usage=show more info in logs"`
}

func (c *AppConfig) GetAllowedOrigins() []string {
	elems := strings.Split(c.AllowedOrigins, ",")
	for i := range elems {
		elems[i] = strings.TrimSpace(elems[i])
	}
	return elems
}
