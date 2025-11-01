package posts

import (
	"encoding/binary"
	"os"
	"testing"
)

func TestService_DecodeFileLink(t *testing.T) {
	mp4Path := "D:\\Dev\\Go\\redstash\\.dev\\develop\\downloads\\t3_1bikyvc\\AttachedAppropriateAmericanriverotter.mp4"

	file, err := os.OpenFile(mp4Path, os.O_RDONLY, 0666)
	if err != nil {
		t.Fatal(err)
	}
	defer file.Close()

	buffer := make([]byte, 8)

	read, err := file.Read(buffer)
	if err != nil {
		t.Fatal(err)
	}

	fileLen := buffer[:4]
	data := binary.BigEndian.Uint64(fileLen)
	t.Log(data)

	t.Log(read)
}
