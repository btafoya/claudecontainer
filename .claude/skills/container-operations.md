---
skill: container-operations
description: Guide for operating Claude Code within the containerized development environment
model: opus
---

# Container Operations Skill

You are operating within a Docker container designed for Claude Code development. This skill provides essential information about the container environment and how to work effectively within it.

## Container Environment

### User Context
- **Running as**: `sandboxuser` (uid: 10001, non-root)
- **Home directory**: `/home/sandboxuser`
- **Working directory**: `/app`
- **Output directory**: `/output`
- **Environment**: `NODE_ENV=production`

### File System Layout
```
/app/                    # Main working directory (read/write access)
  ├── .claude/           # Claude Code configuration
  │   └── agents/        # 8 specialized agent templates
  ├── execute.js         # Application entry point (if present)
  └── package.json       # Node.js dependencies (if present)

/output/                 # Build artifacts and outputs (read/write access)

/usr/local/bin/          # System binaries
  ├── node, npm          # Node.js tools
  ├── python3, pip       # Python tools
  ├── git                # Version control
  ├── uv, uvx            # Python package manager
  └── superclaude        # SuperClaude framework

/usr/local/share/pipx/   # SuperClaude virtual environment
```

## Available Tools & Versions

### Node.js Ecosystem
- **Node.js**: v24.11.1
- **npm**: 11.6.2
- **Claude Agent SDK**: 0.1.55

### Python Ecosystem
- **Python**: 3.12.12
- **pip**: 25.1.1
- **pipx**: 1.7.1
- **uv**: 0.9.13 (fast Python package installer)
- **uvx**: 0.9.13 (run Python packages)

### Development Tools
- **Git**: 2.49.1
- **bash**: 5.2.37
- **SuperClaude**: 4.1.9

### Claude Code Components
- **Agent Templates** (8): ui-ux-designer, frontend-developer, code-reviewer, backend-architect, fullstack-developer, database-architect, nextjs-architecture-expert, security-engineer
- **SuperClaude Framework**: Full framework capabilities available

## Working with Files

### File Permissions
✅ **Can read/write**: `/app/` and `/output/`
❌ **Cannot access**: `/root/`, system directories (read-only)

### Best Practices
1. **Work in /app**: All development work should happen in `/app`
2. **Output to /output**: Place build artifacts, reports, logs in `/output`
3. **Respect permissions**: Don't attempt to modify system files
4. **Use relative paths**: Prefer relative paths within `/app`

### File Operations
```bash
# Writing files - always use /app or /output
echo "content" > /app/myfile.txt          # ✅ Works
echo "content" > /output/result.json      # ✅ Works
echo "content" > /tmp/file.txt            # ⚠️ May not persist

# Reading files
cat /app/package.json                     # ✅ Works
ls -la /app                               # ✅ Works
```

## Package Management

### Python Packages
```bash
# Using uv (fastest method - RECOMMENDED)
uv pip install <package>                  # Install with uv
uvx <package-name>                        # Run package directly

# Using pip
pip install --user <package>              # Install to user directory

# Using pipx (for Python CLI tools)
pipx install <package>                    # Install isolated tool
```

### Node.js Packages
```bash
# Using npm (in /app)
cd /app
npm install <package>                     # Install to /app/node_modules
npm install -g <package>                  # ❌ Cannot install globally

# Using npx
npx <package>                             # Run package directly
```

## SuperClaude Framework

### Available Commands
```bash
superclaude --version                     # Show version (4.1.9)
superclaude doctor                        # Health check
superclaude install                       # Install commands to Claude Code
superclaude install-skill <skill>         # Install a skill
superclaude mcp                           # Manage MCP servers
superclaude update                        # Update framework
```

### Using SuperClaude
```bash
# Check installation health
superclaude doctor

# Install SuperClaude commands to current project
cd /app
superclaude install

# Install a specific skill
superclaude install-skill pytest-analysis
```

## Git Operations

### Git Configuration
```bash
# Configure git (required for commits)
git config --global user.name "Claude Code"
git config --global user.email "claude@anthropic.com"

# Git operations work normally
git status
git add .
git commit -m "message"
git diff
git log
```

### Important Notes
- Git is available and fully functional
- No git credentials are pre-configured
- Cannot push to remote (no SSH keys or credentials)
- Local commits and branching work perfectly

## Process Management

### Running Processes
```bash
# Background processes work
npm start &                               # ✅ Works
python script.py &                        # ✅ Works

# Check running processes
ps aux | grep node                        # View processes
kill <pid>                                # Stop a process
```

### Resource Limits
- Running as non-root limits some system operations
- No access to system services (systemd, etc.)
- Container resource limits apply (CPU, memory)

## Networking

### Network Access
✅ **Outbound connections**: HTTP/HTTPS requests work
✅ **Package downloads**: npm, pip, uv can download packages
❌ **Inbound connections**: No exposed ports by default
❌ **Service binding**: Cannot bind to privileged ports (<1024)

### Common Use Cases
```bash
# HTTP requests work
curl https://api.github.com               # ✅ Works
wget https://example.com/file.txt         # ✅ Works

# Package managers work
npm install express                       # ✅ Works
uv pip install requests                   # ✅ Works
```

## Troubleshooting

### Common Issues

#### Permission Denied
```bash
# ❌ Problem: Trying to write to restricted directory
echo "test" > /etc/hosts

# ✅ Solution: Use /app or /output
echo "test" > /app/config.txt
```

#### Command Not Found
```bash
# Check if tool is installed
which <command>
<command> --version

# For Python packages, use uv or pip
uv pip list                               # List installed packages
```

#### File Not Persisted
```bash
# ❌ Problem: Files in /tmp may not persist
echo "data" > /tmp/file.txt

# ✅ Solution: Use /app or /output for persistent files
echo "data" > /app/data.txt
echo "output" > /output/results.json
```

## Development Workflow

### Recommended Workflow
1. **Navigate to /app**: `cd /app`
2. **Create/modify files**: Work within `/app` directory
3. **Install dependencies**: Use `npm install` or `uv pip install`
4. **Run tests**: Execute with `npm test` or `python -m pytest`
5. **Build outputs**: Write results to `/output`
6. **Commit changes**: Use `git add/commit` for version control

### Example Session
```bash
# Setup
cd /app
git config --global user.name "Claude Code"
git config --global user.email "claude@anthropic.com"

# Development
npm install                               # Install dependencies
npm test                                  # Run tests
npm run build                             # Build project

# Save results
cp dist/* /output/                        # Copy build artifacts
git add .
git commit -m "Build completed"

# Use SuperClaude
superclaude doctor                        # Verify environment
```

## Environment Variables

### Pre-configured
- `HOME=/home/sandboxuser`
- `NODE_ENV=production`
- `PATH` includes `/usr/local/bin`

### Setting Variables
```bash
# For current session
export MY_VAR="value"

# Check environment
env | grep MY_VAR
echo $MY_VAR
```

## Best Practices

### DO
✅ Work in `/app` for all development
✅ Use `/output` for build artifacts
✅ Use `uv` for fast Python package installation
✅ Configure git before committing
✅ Use SuperClaude framework capabilities
✅ Check tool versions with `--version`
✅ Use relative paths within `/app`

### DON'T
❌ Try to modify system files
❌ Expect changes outside `/app` or `/output` to persist
❌ Install packages globally with npm
❌ Bind to privileged ports
❌ Assume root access
❌ Store sensitive data in the container

## Quick Reference

### File Operations
```bash
ls -la /app                               # List files
cat /app/file.txt                         # Read file
echo "data" > /app/new.txt                # Write file
mkdir -p /app/subdir                      # Create directory
cp /app/src.txt /output/dest.txt          # Copy file
```

### Package Management
```bash
uv pip install requests                   # Python (fast)
npm install express                       # Node.js
uvx black myfile.py                       # Run Python tool
npx eslint src/                           # Run Node.js tool
```

### Git Operations
```bash
git status                                # Check status
git add .                                 # Stage changes
git commit -m "msg"                       # Commit
git diff                                  # Show changes
git log --oneline                         # View history
```

### SuperClaude
```bash
superclaude doctor                        # Health check
superclaude install                       # Install to project
superclaude --help                        # Show help
```

## Security Notes

- Running as non-root user (`sandboxuser`) for security
- Limited to `/app` and `/output` directories
- Cannot modify system configuration
- No sudo access
- Isolated from host system

## Container Lifecycle

### Ephemeral Nature
- Container state is temporary
- Only `/app` and `/output` persist if mounted as volumes
- System changes do NOT persist between container runs
- Install dependencies each time if not using volumes

### Volume Mounting
When the container is run with volumes:
```bash
# Host files mounted to /app
-v $(pwd):/app

# Host output directory mounted
-v $(pwd)/output:/output
```
These files WILL persist on the host system.

---

**Remember**: You're in a containerized environment optimized for Claude Code development. Leverage the pre-installed tools (Node.js, Python, Git, SuperClaude) and work within `/app` for the best experience.
