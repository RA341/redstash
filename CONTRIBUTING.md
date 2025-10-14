# Contributing

Thanks for wanting to help make this project better! Here's everything you need to know to get up and running.

Dockman is built with Go for the backend and React for the frontend.

### Project Structure

- **[backend](core)**: The Go backend service
    - **[spec](spec)**: Proto files for the Connect-RPC API [more info](spec/readme.md).
- **[frontend](ui)**: The React frontend application
- **[install](install)**: Installation scripts and documentation (WIP)

### What You'll Need

Before diving in, make sure you have these installed:

- **[Go 1.24+](https://go.dev/dl/)**
- **[Node.js 22+](https://nodejs.org/en/download/)** and npm/yarn
- **[Docker](https://www.docker.com/products/docker-desktop/)** (I mean... DUH!) for testing and updating generated code
- **[Taskfile](https://taskfile.dev/#/installation)** – a modern task runner used for automating development workflows (
  like Make, but nicer)
- **[Coreutils](https://uutils.github.io/coreutils/docs/installation.html)** – used to perform cross-platform file
  operations, since Taskfile doesn't yet support platform-agnostic shell commands
  > Using [uutils/coreutils](https://github.com/uutils/coreutils) as a temporary workaround
  until [Taskfile cross-platform shell support](https://github.com/go-task/task/issues/197#issuecomment-3014045749)
  added

### Init

The easiest way to get started is with our init task that handles everything:

```bash
task init
```

This single command will:

- Create the build directory
- Install npm dependencies
- Build the frontend
- Run `go mod tidy`

### Frontend Development Server

Start the UI development server with hot reload capabilities:

```bash
task ui:r
```

This command runs `npm run dev` in the `ui` directory. The frontend will be accessible at http://localhost:5173 with
automatic hot reload for development.

### Backend Development Server

Open a new terminal window (keep the frontend server running):

```bash
task go:develop
```

This command will:

- Build a Go binary server in the `build/develop` directory
- Create a `develop/` folder structure containing:
    - `compose/` - Docker Compose root directory for all compose files
    - `config/` - Configuration directory containing the SQLite database

The backend will be accessible at http://localhost:8866

**Note:** Go does not support hot reload. To apply code changes, stop the server and rerun the `task go:develop` command
to rebuild with your updates.### Available Task Commands

You can see all available tasks by running:

```bash
task --list
```

#### Common Development Tasks

- **`task init`** - Complete setup for new contributors
- **`task ui`** - Build the frontend
- **`task ui:dep`** - Install UI dependencies
- **`task go:server`** - Build and run the server
- **`task go:b:server`** - Build server binary only
- **`task clean`** - Remove all build files
- **`task tidy`** - Run `go mod tidy` in the core directory

#### Building Specific Components

Build any Go command using the pattern `task go:b:<target>`:

```bash
task go:b:server    # Build server
task go:b:updater   # Build updater
```

Run any Go command using the pattern `task go:<target>`:

```bash
task go:server      # Build and run server
task go:updater     # Build and run updater
```

#### Docker Tasks

- **`task dk:b:<target>`** - Build Docker image for specific target
- **`task dk:<target>`** - Build and run Docker image
- **`task dk:up`** - Build the updater image
- **`task dk:upr`** - Build and run the updater image
- **`task dk:prune`** - Clean up Docker images

#### UI-Specific Tasks

- **`task ui:native`** - Build UI and copy for native binary embedding

### Development Workflow

#### For Frontend Development

1. Run `task init` for initial setup
2. Start backend: `task go:server`
3. Start frontend dev server: `cd ui && npm run dev`
4. Make your changes in the `ui/` directory
5. The dev server will auto-reload for most changes

#### For Backend Development

1. Run `task init` for initial setup
2. Make your changes in the `core/` directory
3. Rebuild and restart: `task go:server`
4. Test with real Docker containers

#### For Full Stack Development

1. Run `task init` for initial setup
2. Use `task ui:native` to rebuild UI for native embedding
3. Rebuild backend: `task go:b:server`
4. Test the integrated application

### Quick Reference

Once everything is running:

- **Backend**: Usually runs on port 8866 (check the terminal output)
- **Frontend Dev Server**: Usually runs on port 5173 (check the terminal output)
- **Docker Compose Root**: The `../stacks` directory (you can change this with the `--cr` flag)
- **Build Output**: All binaries go to the `build/` directory

#### Common Issues & Solutions

- **"Frontend won't load"**: Make sure the backend is running first
- **"Go server won't start"**: Check if you built the frontend with `task ui`
- **"Task not found"**: Make sure you have Taskfile installed and are in the project root
- **"Coreutils command not found"**: Install uutils coreutils as mentioned in the requirements
- **"Something broke"**: Try `task clean` followed by `task init` to start fresh

#### Git ops

Whether you're fixing a bug, adding a feature, or improving documentation:

1. **Start with an issue** - Open an issue first to discuss your idea
2. **Fork and branch** - Create a feature branch from `main`
3. **Make your changes** - Use the task commands for consistent builds
4. **Test thoroughly** - Use both `task go:server` and Docker builds to test
5. **Submit a PR** - Include a clear description of what you've changed

### Need Help?

Not sure where to start? Open an issue tagged with `question` or `help wanted`.

I'm happy to help guide new contributors through the codebase.

If you get stuck, don't hesitate to:

- Open an issue with your problem
- Ask questions in the discussions
- Tag me (@RA341) if you need clarification on anything
- Run `task --list` to see all available commands

