package info

import (
	"github.com/RA341/redstash/pkg/litany"
)

// headers todo
// generated from https://patorjk.com/software/taag/#p=testall&f=Graffiti&t=dockman%0A
var headers = []string{
	// contains some characters that mess with multiline strings leave this alone
	`
                           ░██               ░██                          ░██        
                           ░██               ░██                          ░██        
░██░████  ░███████   ░████████  ░███████  ░████████  ░██████    ░███████  ░████████  
░███     ░██    ░██ ░██    ░██ ░██           ░██          ░██  ░██        ░██    ░██ 
░██      ░█████████ ░██    ░██  ░███████     ░██     ░███████   ░███████  ░██    ░██ 
░██      ░██        ░██   ░███        ░██    ░██    ░██   ░██         ░██ ░██    ░██ 
░██       ░███████   ░█████░██  ░███████      ░████  ░█████░██  ░███████  ░██    ░██
`,
}

const repo = "github.com/RA341/redstash"

func PrintInfo() {
	fields := litany.NewFieldConfig()

	fields.NewStrField("Version", Version)
	fields.NewStrField("Flavour", Flavour)
	fields.NewTimeField("BuildDate", BuildDate)
	fields.DashDivider()

	fields.NewStrField("Branch", Branch)
	fields.NewStrField("CommitInfo", CommitInfo)
	fields.NewStrField("GoVersion", GoVersion)

	if IsKnown(Branch) && IsKnown(CommitInfo) {
		fields.DashDivider()
		fields.NewGithubMetadata(
			repo,
			Branch,
			CommitInfo,
		)
	}

	fields.EqualDivider()

	litany.Announce(headers, fields)
}
