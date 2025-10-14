FROM golang:1-alpine AS back

WORKDIR /core

# for sqlite
ENV CGO_ENABLED=1

RUN apk update && apk add --no-cache gcc musl-dev

COPY core/go.mod core/go.sum ./

RUN go mod download

COPY core/ .

# These ARGs are automatically populated by Docker Buildx for each platform.
# e.g., for 'linux/arm64', TARGETOS becomes 'linux' and TARGETARCH becomes 'arm64'.
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG VERSION=dev
ARG COMMIT_INFO=unknown
ARG BRANCH=unknown
ARG INFO_PACKAGE=github.com/RA341/redstash/internal/info

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w \
             -X ${INFO_PACKAGE}.Flavour=Docker \
             -X ${INFO_PACKAGE}.Version=${VERSION} \
             -X ${INFO_PACKAGE}.CommitInfo=${COMMIT_INFO} \
             -X ${INFO_PACKAGE}.BuildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
             -X ${INFO_PACKAGE}.Branch=${BRANCH}" \
    -o redstash "./cmd/server"

FROM alpine:latest AS alpine

WORKDIR /app

COPY --from=back /core/redstash redstash

EXPOSE 8558

ENTRYPOINT ["./redstash"]
