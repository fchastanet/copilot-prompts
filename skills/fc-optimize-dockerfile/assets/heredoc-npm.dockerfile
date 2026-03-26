# =============================================================================
# Heredoc Example: Node.js NPM Package Installation
# =============================================================================
# This example demonstrates the proper way to install Node.js packages using
# heredoc syntax with cache cleanup.
# =============================================================================

FROM node:18-slim

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

RUN <<EOF
# Install Node.js dependencies
npm ci --omit=dev --no-cache

# Remove npm cache and unnecessary files
npm cache clean --force
rm -rf /root/.npm /tmp/*
EOF
