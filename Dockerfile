FROM node:24-alpine 

# Install development tools
RUN apk --no-cache add git bash python3 py3-pip curl pipx \
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
    --agent development-team/ui-ux-designer,development-team/frontend-developer,development-tools/code-reviewer,development-team/backend-architect,development-team/fullstack-developer,database/database-architect,web-tools/nextjs-architecture-expert,devops-infrastructure/security-engineer

# Copy container operations skill
COPY .claude/skills/container-operations.md /app/.claude/skills/container-operations.md

# Install SuperClaude Framework via pipx and make it globally accessible
RUN pipx install git+https://github.com/SuperClaude-Org/SuperClaude_Framework.git \
    && cp -r /root/.local/share/pipx /usr/local/share/ \
    && cp /root/.local/bin/superclaude /usr/local/bin/superclaude \
    && sed -i 's|/root/.local/share/pipx|/usr/local/share/pipx|g' /usr/local/bin/superclaude \
    && chmod -R 755 /usr/local/share/pipx /usr/local/bin/superclaude

# Set proper permissions for workspace
RUN mkdir -p /output \
    && chown -R sandboxuser:sandboxuser /app /output

# Copy execution scripts
COPY execute.js /app/execute.js
COPY package.json /app/package.json

# Install dependencies
RUN npm install --production && \
    chown -R sandboxuser:sandboxuser /app

# Run as non-root user
USER sandboxuser
ENV HOME=/home/sandboxuser
ENV NODE_ENV=production
CMD ["node", "/app/execute.js"]