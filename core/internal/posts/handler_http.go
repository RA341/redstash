package posts

import (
	"net/http"
	"os"
	"path/filepath"

	"github.com/RA341/redstash/pkg/fileutil"
)

type HandlerHttp struct {
	srv *Service
}

func NewHandlerHttp(service *Service) http.Handler {
	hand := &HandlerHttp{srv: service}
	return hand.register()
}

func (h *HandlerHttp) register() http.Handler {
	subMux := http.NewServeMux()
	subMux.HandleFunc("GET /{filename...}", h.loadFile)

	return subMux
}

func (h *HandlerHttp) loadFile(w http.ResponseWriter, r *http.Request) {
	fileName := r.PathValue("filename")
	if fileName == "" {
		http.Error(w, "Filename not provided", http.StatusBadRequest)
		return
	}
	cleanPath := filepath.Clean(fileName)
	fullPath := h.srv.DecodeFileLink(cleanPath)
	
	file, err := os.Open(fullPath)
	if err != nil {
		http.Error(w, "Video not found", http.StatusNotFound)
		return
	}
	defer fileutil.Close(file)

	fileInfo, err := file.Stat()
	if err != nil {
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	// ServeContent handles ranges, etags, and caching automatically
	w.Header().Set("Content-Type", "video/mp4")
	http.ServeContent(w, r, fileInfo.Name(), fileInfo.ModTime(), file)
}
