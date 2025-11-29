# Claude Container - Docker Environment

[![Docker](https://img.shields.io/badge/Docker-24.0+-blue.svg)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-24.11.1-green.svg)](https://nodejs.org/)
[![Python](https://img.shields.io/badge/Python-3.12.12-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-btafoya%2Fclaudecontainer-black.svg)](https://github.com/btafoya/claudecontainer)

Docker container with Claude Code development tools, agent templates, and SuperClaude framework.

**Repository**: [https://github.com/btafoya/claudecontainer](https://github.com/btafoya/claudecontainer)

## Table of Contents

- [Quick Start](#quick-start)
- [What's Installed](#whats-installed)
- [SuperClaude Usage](#superclaude-usage)
- [VS Code Integration](#vs-code-integration)
- [Documentation](#documentation)
- [Build Info](#build-info)
- [Key Features](#key-features)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Quick Start

### Clone the Repository

```bash
# Clone from GitHub
git clone https://github.com/btafoya/claudecontainer.git
cd claudecontainer
```

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

### Pull from GitHub Container Registry (Future)

```bash
# Once published to GHCR
# docker pull ghcr.io/btafoya/claudecontainer:latest
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
- **Claude Code Settings** in `/app/.claude/settings.json` (Git attribution disabled)

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

### Core Documentation
- **[VS Code Integration Guide](docs/VSCODE_INTEGRATION.md)** - Complete VS Code setup, MCP configuration, and development workflows 🆕
- **[Final Test Report](docs/FINAL_TEST_REPORT.md)** - Comprehensive testing and production readiness validation 🆕
- **[Dockerfile Test Report](docs/DOCKERFILE_TEST_REPORT.md)** - Detailed build and component verification 🆕

### Additional Resources
- **[Dockerfile](Dockerfile)** - Complete container configuration
- **[docker-compose.yml](docker-compose.yml)** - Docker Compose configuration
- **[.claude/skills/container-operations.md](.claude/skills/container-operations.md)** - Container operations skill (361 lines)

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
✅ Git attribution disabled (clean commits) 🆕
✅ Fixed uv/uvx installation
✅ Proper directory permissions
✅ Non-root execution (security)
✅ All tools verified working (9/9 tests passed)

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository: [https://github.com/btafoya/claudecontainer/fork](https://github.com/btafoya/claudecontainer/fork)
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Reporting Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/btafoya/claudecontainer/issues/new)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- **GitHub Repository**: [https://github.com/btafoya/claudecontainer](https://github.com/btafoya/claudecontainer)
- **Issues**: [https://github.com/btafoya/claudecontainer/issues](https://github.com/btafoya/claudecontainer/issues)
- **Pull Requests**: [https://github.com/btafoya/claudecontainer/pulls](https://github.com/btafoya/claudecontainer/pulls)

## Support

For questions or support:
- Open an [issue](https://github.com/btafoya/claudecontainer/issues)
- Check the [documentation](docs/)
- Review the [VS Code Integration Guide](docs/VSCODE_INTEGRATION.md)

---

**Status**: ✅ Production Ready
**Last Updated**: 2025-11-28
**Maintainer**: [@btafoya](https://github.com/btafoya)
