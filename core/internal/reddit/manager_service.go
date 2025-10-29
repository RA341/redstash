package reddit

import (
	"fmt"

	"github.com/RA341/redstash/pkg/syncmap"
	"github.com/rs/zerolog/log"
)

type ManagerService struct {
	store CredentialStore
	posts PostStore

	// todo remove after some time and load on demand
	clients         syncmap.Map[string, *ClientService]
	triggerDownload func()
}

func NewManagerService(store CredentialStore, postStore PostStore, triggerDownload func()) *ManagerService {
	m := &ManagerService{
		store:           store,
		posts:           postStore,
		triggerDownload: triggerDownload,
	}
	m.LoadClients()

	return m
}

func (s *ManagerService) LoadClients() {
	list, err := s.List()
	if err != nil {
		log.Warn().Err(err).Msg("Failed to list clients")
	}

	for _, accountInfo := range list {
		_, ok := s.clients.Load(accountInfo.Username)
		if ok {
			log.Info().Str("name", accountInfo.Username).Msg("Client already loaded")
			continue
		}

		cli := NewClientService(
			&accountInfo,
			s.store,
			s.posts,
			s.triggerDownload,
		)

		s.clients.Store(accountInfo.Username, cli)
		log.Info().Str("name", accountInfo.Username).Msg("Client loaded")
	}
}

func (s *ManagerService) List() ([]Credential, error) {
	return s.store.List()
}

func (s *ManagerService) Create(cred *Credential) error {
	err := CheckCredentials(cred, nil)
	if err != nil {
		return fmt.Errorf("unable to verfiy credentials %w", err)
	}

	return s.store.New(cred)
}

func (s *ManagerService) Delete(id uint) error {
	return s.store.Delete(id)
}
