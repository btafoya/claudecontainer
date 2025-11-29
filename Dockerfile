FROM node:24-alpine 

# Install development tools
RUN apk --no-cache add git bash python3 py3-pip curl pipx \
    && npm install -g @anthropic-ai/claude-code \
    && npm install -g @anthropic-ai/claude-agent-sdk \
    && curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy uv binaries to system location (uv installs to /root/.local/bin, not /root/.cargo/bin)
RUN cp /root/.local/bin/uv /usr/local/bin/uv \
    && cp /root/.local/bin/uvx /usr/local/bin/uvx \
    && chmod 755 /usr/local/bin/uv /usr/local/bin/uvx

# Create non-root user for security
RUN adduser -u 10001 -D -s /bin/bash sandboxuser

# Set up workspace and output directory
WORKDIR /app

# Install Claude Code agent templates to /app/.claude
RUN npx claude-code-templates@latest \
    --agent development-team/ui-ux-designer,development-team/frontend-developer,development-tools/code-reviewer,development-team/backend-architect,development-team/fullstack-developer,database/database-architect,web-tools/nextjs-architecture-expert,devops-infrastructure/security-engineer \
    --command "project-management/todo,deployment/add-changelog,deployment/containerize-application,orchestration/resume,team/session-learning-capture" \
    --setting "statusline/context-monitor" \
    --hook "automation/simple-notifications" \
    --mcp "integration/memory-integration" \
    --yes

# Copy container operations skill
COPY .claude/skills/container-operations.md /app/.claude/skills/container-operations.md

# Install SuperClaude Framework via pipx and make it globally accessible
RUN pipx install SuperClaude \
    && cp -r /root/.local/share/pipx /usr/local/share/ \
    && cp /root/.local/bin/superclaude /usr/local/bin/superclaude \
    && cp /root/.local/bin/SuperClaude /usr/local/bin/SuperClaude 2>/dev/null || true \
    && sed -i 's|/root/.local/share/pipx|/usr/local/share/pipx|g' /usr/local/bin/superclaude \
    && sed -i 's|/root/.local/share/pipx|/usr/local/share/pipx|g' /usr/local/bin/SuperClaude 2>/dev/null || true \
    && chmod -R 755 /usr/local/share/pipx /usr/local/bin/superclaude /usr/local/bin/SuperClaude 2>/dev/null || true

# Install SuperClaude commands and copy to /app for sandboxuser access
RUN superclaude install && \
    cp -r /root/.claude/commands/sc /app/.claude/commands/ && \
    chown -R sandboxuser:sandboxuser /app/.claude/commands/sc

# Install MCP servers: serena, context7, sequential-thinking, playwright
# Note: These are installed via npm and configured in .mcp.json for Claude Code
RUN npm install -g @modelcontextprotocol/server-serena \
    @modelcontextprotocol/server-context7 \
    @modelcontextprotocol/server-sequential-thinking \
    @modelcontextprotocol/server-playwright || \
    echo "Warning: Some MCP servers may not be available via npm"

# Set proper permissions for workspace
RUN mkdir -p /output \
    && chown -R sandboxuser:sandboxuser /app /output

# Run as non-root user
USER sandboxuser
ENV HOME=/home/sandboxuser
ENV NODE_ENV=production

# Default command (interactive shell)
CMD ["bash"]