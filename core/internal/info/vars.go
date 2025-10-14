package info

import (
	"runtime"
	"strings"
)

// build args to modify vars
//
// -X github.com/RA341/dockman/internal/info.Version=${VERSION} \
// -X github.com/RA341/dockman/internal/info.CommitInfo=${COMMIT_INFO} \
// -X github.com/RA341/dockman/internal/info.BuildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
// -X github.com/RA341/dockman/internal/info.Branch=${BRANCH}" \
// cmd/server.go

// defaults
const (
	VersionDev = "develop"
	Unknown    = "unknown"
)

// flavours
const (
	Server = "server"
	Docker = "docker"
)

var (
	Flavour    = Server
	Version    = VersionDev
	CommitInfo = Unknown
	BuildDate  = Unknown
	Branch     = Unknown
	GoVersion  = runtime.Version()
)

func IsKnown(val string) bool {
	return val != Unknown
}

func IsDocker() bool {
	return strings.ToLower(Flavour) == Docker
}

func IsDev() bool {
	return strings.ToLower(Version) == VersionDev
}
