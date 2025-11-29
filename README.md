# Claude Container - Docker Environment

Docker container with Claude Code development tools, agent templates, and SuperClaude framework.

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Build and start the container
docker-compose up -d

# Access interactive shell
docker-compose exec claudecontainer sh

# Stop the container
docker-compose down

# Rebuild after Dockerfile changes
docker-compose build
docker-compose up -d
```

### Using Docker Directly

```bash
# Build the image
docker build -t claudecontainer:latest .

# Run with your project
docker run --rm -v $(pwd):/app -v $(pwd)/output:/output claudecontainer:latest

# Interactive shell
docker run --rm -it -v $(pwd):/app claudecontainer:latest sh
```

## What's Installed

### Development Tools
- **Node.js** 24.11.1
- **Python** 3.12.12
- **Git** 2.49.1
- **uv/uvx** 0.9.13 (Python package manager)
- **Claude CLI** 2.0.55 (for MCP management) 🆕
- **Claude Agent SDK** 0.1.55
- **SuperClaude** 4.1.9 ⭐

### Claude Code Components
- **8 Agent Templates** in `/app/.claude/agents/`
- **31 SuperClaude Commands** in `/app/.claude/commands/sc/` 🆕
- **Container Operations Skill** in `/app/.claude/skills/`
- **SuperClaude Framework** at `/usr/local/bin/superclaude`

## SuperClaude Usage

```bash
# Check installation
docker run --rm claudecontainer:latest superclaude doctor

# Show version
docker run --rm claudecontainer:latest superclaude --version

# Install SuperClaude commands
docker run --rm -v $(pwd):/app claudecontainer:latest superclaude install
```

## VS Code Integration

**NEW**: Complete Visual Studio Code integration guide available!

See **[VSCODE_INTEGRATION.md](docs/VSCODE_INTEGRATION.md)** for:
- 🔧 VS Code setup and configuration
- 🐳 Remote container development
- 🔌 MCP server configuration (Context7, Serena, Sequential Thinking, Playwright)
- 💻 Development workflows and best practices
- 🐛 Debugging and troubleshooting

### Quick VS Code Setup

```bash
# Install Remote - Containers extension
code --install-extension ms-vscode-remote.remote-containers

# Open project in container
code .
# Press F1 → "Remote-Containers: Open Folder in Container"
```

## Documentation

- **[docs/VSCODE_INTEGRATION.md](docs/VSCODE_INTEGRATION.md)** - VS Code setup and MCP configuration 🆕
- **[docs/FINAL_TEST_REPORT.md](docs/FINAL_TEST_REPORT.md)** - Comprehensive testing and validation 🆕
- **[docs/DOCKERFILE_TEST_REPORT.md](docs/DOCKERFILE_TEST_REPORT.md)** - Detailed test results 🆕
- **DOCKER_COMPOSE_GUIDE.md** - Complete docker-compose usage guide
- **COMPLETE_SUMMARY.md** - Full overview of all changes
- **SUPERCLAUDE_INSTALLATION.md** - SuperClaude setup details
- **TEMPLATE_INSTALLATION_SUMMARY.md** - Agent templates info
- **SKILL_DOCUMENTATION.md** - Container operations skill details
- **TEST_REPORT.md** - Initial testing results and fixes

## Build Info

- **Base**: node:24-alpine
- **User**: sandboxuser (uid=10001)
- **Working Dir**: /app
- **Build Time**: ~120 seconds (first), <10 seconds (cached)
- **Image Size**: ~550-600 MB

## Key Features

✅ Claude CLI 2.0.55 for MCP management 🆕
✅ 31 SuperClaude slash commands 🆕
✅ 16 Claude Code components (agents, commands, settings)
✅ SuperClaude Framework 4.1.9
✅ Container operations skill (361 lines)
✅ Fixed uv/uvx installation
✅ Proper directory permissions
✅ Non-root execution (security)
✅ All tools verified working (9/9 tests passed)

---

**Status**: ✅ Production Ready  
**Last Updated**: 2025-11-28
