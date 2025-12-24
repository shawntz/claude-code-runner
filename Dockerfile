FROM node:20-slim

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ssh \
    && rm -rf /var/lib/apt/lists/*

# gh CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Git config for commits
RUN git config --global user.email "claude-bot@localhost" \
    && git config --global user.name "Claude Bot"

WORKDIR /app
COPY package.json ./
RUN npm install
COPY src ./src

EXPOSE 3000
CMD ["node", "src/server.js"]
