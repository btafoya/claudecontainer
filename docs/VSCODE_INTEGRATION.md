# Visual Studio Code Integration Guide

Complete guide for using the claudecontainer Docker environment with Visual Studio Code, including MCP server configuration and development workflows.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [VS Code Setup](#vs-code-setup)
3. [Container Integration](#container-integration)
4. [MCP Server Configuration](#mcp-server-configuration)
5. [Development Workflows](#development-workflows)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

**VS Code**:
- Version: Latest stable release
- Download: https://code.visualstudio.com/

**Docker**:
- Docker Desktop (macOS/Windows) or Docker Engine (Linux)
- Docker Compose v2.x
- Download: https://www.docker.com/products/docker-desktop/

**Extensions** (Install via VS Code Extensions Marketplace):
1. **Remote - Containers** (ms-vscode-remote.remote-containers)
2. **Docker** (ms-azuretools.vscode-docker)
3. **Claude for VS Code** (anthropic.claude-vscode) - Optional but recommended

### Optional Tools

- **Git**: For version control
- **Claude CLI**: For MCP server management (included in container)

---

## VS Code Setup

### 1. Install Required Extensions

```bash
# Install Remote - Containers extension
code --install-extension ms-vscode-remote.remote-containers

# Install Docker extension
code --install-extension ms-azuretools.vscode-docker

# Optional: Install Claude extension
code --install-extension anthropic.claude-vscode
```

### 2. Configure VS Code Settings

Create or update `.vscode/settings.json` in your project:

```json
{
  "remote.containers.defaultExtensions": [
    "ms-vscode-remote.remote-containers",
    "ms-azuretools.vscode-docker"
  ],
  "docker.dockerComposePath": "docker-compose",
  "terminal.integrated.defaultProfile.linux": "bash",
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/output/**": true
  }
}
```

### 3. Create Dev Container Configuration

Create `.devcontainer/devcontainer.json`:

```json
{
  "name": "Claude Container Development",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "claudecontainer",
  "workspaceFolder": "/app",

  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"
      ],
      "settings": {
        "terminal.integrated.defaultProfile.linux": "bash",
        "python.defaultInterpreterPath": "/usr/bin/python3",
        "python.linting.enabled": true
      }
    }
  },

  "forwardPorts": [3000, 8080],
  "postCreateCommand": "superclaude doctor",
  "remoteUser": "sandboxuser"
}
```

---

## Container Integration

### Method 1: Using Remote - Containers (Recommended)

#### Step 1: Open Project in Container

1. Open VS Code
2. Press `F1` or `Cmd+Shift+P` (Mac) / `Ctrl+Shift+P` (Windows/Linux)
3. Type: "Remote-Containers: Open Folder in Container"
4. Select your project folder containing `docker-compose.yml`
5. VS Code will build and connect to the container

#### Step 2: Verify Container Connection

Look for the green indicator in the bottom-left corner showing:
```
>< Dev Container: Claude Container Development
```

#### Step 3: Open Integrated Terminal

- Press `` Ctrl+` `` or `Cmd+` ``
- You should see a bash prompt as `sandboxuser@<container-id>:/app$`

### Method 2: Using Docker Compose Manually

#### Step 1: Start Container

```bash
# From project root
docker-compose up -d
```

#### Step 2: Attach VS Code

1. Click on Docker icon in VS Code sidebar
2. Find "claudecontainer" under "Containers"
3. Right-click → "Attach Visual Studio Code"
4. VS Code opens new window connected to container

### Method 3: Using Docker Extension

1. Install Docker extension in VS Code
2. View → Command Palette (`Cmd+Shift+P`)
3. Type: "Docker: Attach Shell"
4. Select `claudecontainer`
5. Integrated terminal opens in container

---

## MCP Server Configuration

### Understanding MCP Servers

MCP (Model Context Protocol) servers provide Claude with additional capabilities like:
- **Context7**: Documentation and code context
- **Serena**: Semantic code analysis
- **Sequential Thinking**: Multi-step reasoning
- **Playwright**: Browser automation

### Configuration File Structure

MCP servers are configured in Claude Code's configuration file. Here's the pattern based on Context7 MCP server configuration:

#### Location Options

1. **User-level** (affects all projects):
   - macOS/Linux: `~/.claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`

2. **Project-level** (container):
   - `/app/.claude/mcp_config.json` (created by container)

### Example MCP Configuration (Context7 Pattern)

Create or update `~/.claude/claude_desktop_config.json` on your **host machine**:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": [
        "-y",
        "@context7/mcp-server"
      ],
      "env": {
        "CONTEXT7_API_KEY": "your-api-key-here"
      }
    },
    "serena": {
      "command": "npx",
      "args": [
        "-y",
        "@serena/mcp-server"
      ],
      "cwd": "/path/to/your/project"
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-playwright"
      ]
    }
  }
}
```

### Container-Specific MCP Setup

Since the container includes the Claude CLI, you can configure MCP servers from within:

#### Inside Container

```bash
# Enter container
docker-compose exec claudecontainer bash

# Configure MCP servers using Claude CLI
claude mcp add context7 \
  --command npx \
  --args "-y @context7/mcp-server" \
  --env CONTEXT7_API_KEY=your-key

# List configured servers
claude mcp list

# Test server connection
claude mcp test context7
```

### SuperClaude MCP Integration

The container includes SuperClaude's MCP management. Configure via:

```bash
# Inside container
superclaude mcp --servers context7 --scope project

# This creates project-level MCP configuration
# Location: /app/.claude/mcp_config.json
```

### VS Code + Container MCP Workflow

**Important**: MCP servers run on the **host machine**, not in the container. The container provides the development environment, while MCP servers are managed by Claude Desktop/Code on your host.

**Recommended Setup**:

1. **Host Machine**: Configure MCP servers in Claude Desktop
2. **Container**: Develop code with all tools available
3. **VS Code**: Connect to container for development
4. **Claude Code**: Uses host MCP servers for enhanced capabilities

---

## Development Workflows

### Workflow 1: Standard Development

```bash
# 1. Start container
docker-compose up -d

# 2. Open in VS Code
code .

# 3. Attach to container (Remote - Containers extension)
# F1 → "Remote-Containers: Attach to Running Container"

# 4. Inside container terminal
cd /app
npm install
npm run dev

# 5. Code with full tool access
git status
python3 script.py
superclaude doctor
```

### Workflow 2: Using SuperClaude Commands

```bash
# Inside container (VS Code terminal)

# Research a topic
/sc:research "Docker networking patterns"

# Analyze code
/sc:analyze src/

# Generate documentation
/sc:document components/

# Implement feature
/sc:implement "Add authentication middleware"

# Test implementation
/sc:test

# Clean up code
/sc:cleanup
```

### Workflow 3: Git Operations

```bash
# Inside container

# Configure git (first time only)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Standard git workflow
git status
git add .
git commit -m "feat: add new feature"
git push

# Or use SuperClaude git command
/sc:git commit "Add authentication"
```

### Workflow 4: Python Development

```bash
# Inside container

# Fast package installation with uv
uv pip install requests pandas numpy

# Or use standard pip
pip install --user flask

# Run Python scripts
python3 app.py

# Use pipx for CLI tools
pipx install black
black src/
```

### Workflow 5: Node.js Development

```bash
# Inside container

# Install dependencies
npm install

# Run development server
npm run dev

# Execute CLI tools without global install
npx eslint .
npx prettier --write .

# Build for production
npm run build

# Output goes to /output (accessible on host)
```

---

## Advanced VS Code Features

### 1. Debugging in Container

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "cwd": "/app"
    },
    {
      "name": "Node: Attach",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "address": "localhost",
      "restart": true,
      "sourceMaps": true,
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app"
    }
  ]
}
```

### 2. Tasks Configuration

Create `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build",
      "type": "shell",
      "command": "npm run build",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": []
    },
    {
      "label": "Test",
      "type": "shell",
      "command": "npm test",
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "SuperClaude Doctor",
      "type": "shell",
      "command": "superclaude doctor"
    }
  ]
}
```

### 3. Workspace Recommendations

Create `.vscode/extensions.json`:

```json
{
  "recommendations": [
    "ms-vscode-remote.remote-containers",
    "ms-azuretools.vscode-docker",
    "ms-python.python",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens"
  ]
}
```

---

## Troubleshooting

### Issue: Container Won't Start

**Symptoms**: VS Code can't connect, docker-compose fails

**Solutions**:
```bash
# Check if container is running
docker ps

# View logs
docker-compose logs

# Rebuild container
docker-compose build --no-cache
docker-compose up -d

# Remove and recreate
docker-compose down -v
docker-compose up -d
```

### Issue: Permission Denied Errors

**Symptoms**: Can't write to /app, permission errors

**Solutions**:
```bash
# Inside container - verify user
whoami
# Should show: sandboxuser

# Check directory permissions
ls -la /app /output

# If needed, rebuild container (permissions set during build)
docker-compose down
docker-compose build
docker-compose up -d
```

### Issue: MCP Servers Not Working

**Symptoms**: Claude Code can't access MCP capabilities

**Solutions**:

1. **Verify MCP configuration location**:
   ```bash
   # On host machine
   cat ~/.claude/claude_desktop_config.json
   ```

2. **Check Claude Desktop is running** (on host)

3. **Test MCP server installation**:
   ```bash
   # On host
   npx -y @context7/mcp-server --version
   ```

4. **Restart Claude Desktop** (on host)

### Issue: VS Code Can't Find Python/Node

**Symptoms**: Intellisense not working, wrong interpreter

**Solutions**:

1. **Set Python interpreter**:
   - `Cmd+Shift+P` → "Python: Select Interpreter"
   - Choose `/usr/bin/python3`

2. **Verify Node.js path**:
   ```bash
   which node
   # Should show: /usr/local/bin/node
   ```

3. **Update VS Code settings**:
   ```json
   {
     "python.defaultInterpreterPath": "/usr/bin/python3",
     "python.pythonPath": "/usr/bin/python3"
   }
   ```

### Issue: Port Forwarding Not Working

**Symptoms**: Can't access localhost:3000 from host

**Solutions**:

1. **Check port forwarding in devcontainer.json**:
   ```json
   "forwardPorts": [3000, 8080]
   ```

2. **Manually forward ports**:
   - VS Code → Ports tab (bottom panel)
   - Click "Forward a Port"
   - Enter port number

3. **Use docker-compose port mapping**:
   ```yaml
   ports:
     - "3000:3000"
     - "8080:8080"
   ```

### Issue: Changes Not Persisting

**Symptoms**: Files disappear after container restart

**Solutions**:

1. **Verify volume mounts** in `docker-compose.yml`:
   ```yaml
   volumes:
     - .:/app          # Host → Container
     - ./output:/output
   ```

2. **Work in /app directory** (mounted volume)

3. **Never work in /tmp** (ephemeral)

---

## Best Practices

### 1. Project Structure

```
your-project/
├── .vscode/
│   ├── settings.json
│   ├── launch.json
│   └── extensions.json
├── .devcontainer/
│   └── devcontainer.json
├── .claude/
│   ├── commands/
│   └── skills/
├── src/
├── output/
├── docker-compose.yml
└── README.md
```

### 2. Git Workflow in Container

```bash
# Always configure git first time
git config --global user.name "Your Name"
git config --global user.email "email@example.com"

# Use feature branches
git checkout -b feature/new-feature

# Commit frequently
git add .
git commit -m "feat: descriptive message"

# Push requires host credentials
# Either: configure git credentials helper
# Or: push from host machine
```

### 3. Environment Variables

**In Container** (temporary):
```bash
export API_KEY="your-key"
```

**In docker-compose.yml** (persistent):
```yaml
services:
  claudecontainer:
    environment:
      - API_KEY=your-key
      - NODE_ENV=development
```

**In .env file** (recommended):
```bash
# Create .env in project root
API_KEY=your-key
DATABASE_URL=postgresql://...

# Add to .gitignore
echo ".env" >> .gitignore
```

### 4. Performance Optimization

**For macOS/Windows**:
- Use named volumes for node_modules (faster)
- Enable file sharing in Docker Desktop settings
- Increase Docker Desktop memory allocation (4GB+)

**Volume configuration**:
```yaml
volumes:
  - .:/app
  - /app/node_modules  # Don't sync node_modules to host
  - ./output:/output
```

---

## Quick Reference

### Essential Commands

```bash
# Container Management
docker-compose up -d              # Start container
docker-compose down               # Stop container
docker-compose restart            # Restart container
docker-compose exec claudecontainer bash  # Enter shell

# VS Code
code .                            # Open project
F1 → "Remote-Containers: Reopen in Container"
Ctrl+` (Cmd+`)                    # Toggle terminal

# Inside Container
superclaude doctor                # Health check
claude --version                  # Verify Claude CLI
git status                        # Git operations
npm install                       # Install dependencies
uv pip install <package>          # Fast Python install
```

### File Locations

```
Host:
  ~/.claude/claude_desktop_config.json    # MCP configuration
  /path/to/project/                       # Your code

Container:
  /app/                                   # Mounted project
  /output/                                # Build outputs
  /app/.claude/commands/sc/               # SuperClaude commands
  /app/.claude/skills/                    # Container skills
  /usr/local/bin/superclaude              # SuperClaude CLI
  /usr/local/bin/claude                   # Claude CLI
```

---

## Additional Resources

**Documentation**:
- Claude Code: https://docs.claude.ai/
- VS Code Remote Containers: https://code.visualstudio.com/docs/remote/containers
- Docker Compose: https://docs.docker.com/compose/
- SuperClaude: https://github.com/SuperClaude-Org/SuperClaude_Framework

**Project Files**:
- DOCKERFILE_TEST_REPORT.md - Complete testing results
- FINAL_TEST_REPORT.md - Production readiness assessment
- README.md - Quick start guide
- DOCKER_COMPOSE_GUIDE.md - Docker Compose reference

---

**Last Updated**: 2025-11-28
**Container Version**: claudecontainer:latest
**Status**: ✅ Production Ready
