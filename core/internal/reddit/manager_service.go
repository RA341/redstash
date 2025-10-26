package reddit

import (
	"fmt"

	"github.com/RA341/redstash/pkg/syncmap"
)

type ManagerService struct {
	store CredentialStore

	clients syncmap.Map[string, *Service]
}

func NewManagerService(store CredentialStore, postStore PostStore) *ManagerService {
	return &ManagerService{store: store}
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
