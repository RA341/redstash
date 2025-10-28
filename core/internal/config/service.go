package config

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"

	"github.com/RA341/redstash/pkg/argos"
)

const EnvPrefix = "REDSTASH"

func Load() (*AppConfig, error) {
	config, err := loadConfig()
	if err != nil {
		return nil, err
	}

	uiPath := config.UIPath
	if uiPath != "" {
		if file, err := WithUIFromFile(uiPath); err == nil {
			config.UIFS = file
		}
	}

	argos.PrettyPrint(config, EnvPrefix)
	return config, nil
}

func loadConfig() (*AppConfig, error) {
	conf := &AppConfig{}
	if err := argos.Scan(conf, EnvPrefix); err != nil {
		return nil, err
	}
	flag.Parse()

	pathsToResolve := []*string{
		&conf.ConfigDir,
		&conf.DownloadDir,
	}
	for _, p := range pathsToResolve {
		absPath, err := filepath.Abs(*p)
		if err != nil {
			return nil, fmt.Errorf("failed to get abs path for %s: %w", *p, err)
		}
		*p = absPath

		if err = os.MkdirAll(absPath, 0777); err != nil {
			return nil, err
		}
	}

	return conf, nil
}
