package reddit

import (
	"fmt"

	"github.com/RA341/redstash/internal/config"
	"github.com/RA341/redstash/pkg/syncmap"
	"github.com/rs/zerolog/log"
)

type ManagerService struct {
	store CredentialStore
	posts PostStore

	// todo remove after some time and load on demand
	clients         syncmap.Map[string, *ClientService]
	triggerDownload func()
	conf            ConfigProvider
}

type ConfigProvider func() config.Reddit

func NewManagerService(
	conf ConfigProvider,
	store CredentialStore,
	postStore PostStore,
	triggerDownload func(),
) *ManagerService {
	return &ManagerService{
		store:           store,
		posts:           postStore,
		triggerDownload: triggerDownload,
		conf:            conf,
	}
}
func (s *ManagerService) TriggerPostCollector() {
	s.clients.Range(func(key string, value *ClientService) bool {
		value.task.Manual()
		return true
	})
}

func (s *ManagerService) LoadAllClients() error {
	list, err := s.List()
	if err != nil {
		return fmt.Errorf("failed to list clients: %w", err)
	}

	for _, accountInfo := range list {
		_, ok := s.clients.Load(accountInfo.Username)
		if ok {
			log.Info().Str("name", accountInfo.Username).Msg("Client already loaded")
			continue
		}

		s.loadClient(accountInfo)
	}
	s.TriggerPostCollector()

	return nil
}

func (s *ManagerService) loadClient(accountInfo Credential) {
	cli := NewClientService(
		s.conf,
		&accountInfo,
		s.store,
		s.posts,
		s.triggerDownload,
	)

	s.clients.Store(accountInfo.Username, cli)
	log.Info().Str("name", accountInfo.Username).Msg("Client loaded")
}

func (s *ManagerService) List() ([]Credential, error) {
	return s.store.List()
}

func (s *ManagerService) Create(cred *Credential) error {
	err := CheckCredentials(cred, nil)
	if err != nil {
		return fmt.Errorf("unable to verfiy credentials %w", err)
	}

	err = s.store.New(cred)
	if err != nil {
		return err
	}

	err = s.LoadAllClients()
	if err != nil {
		return err
	}

	s.TriggerPostCollector()

	return nil
}

func (s *ManagerService) Delete(id uint) error {
	err := s.store.Delete(id)
	if err != nil {
		return err
	}

	// todo download

	return nil
}
