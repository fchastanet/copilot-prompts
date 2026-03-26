# =============================================================================
# COMPLETE DOCKERFILE TEMPLATE
# =============================================================================
# This template incorporates ALL best practices from the fc-optimize-dockerfile
# skill. Use as a starting point and customize based on your application requirements.
# =============================================================================

# =============================================================================
# STAGE DIAGRAM
# =============================================================================
# This multi-stage build follows this flow:
#
#   base (shared dependencies)
#    ├─> development (dev tools + hot reload)
#    ├─> dependencies (prod + build deps)
#    │    ├─> builder (compile/build)
#    │    │    └─> test (run tests)
#    │    │         └─> security-scan (vulnerability scan)
#    │    │              └─> production (minimal runtime)
#    │    └─> production (direct path for interpreted languages)
#
# =============================================================================

# =============================================================================
# BASE STAGE: Shared foundation for all stages
# =============================================================================
FROM ubuntu:22.04 AS base

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Build argument for non-interactive apt-get
ARG DEBIAN_FRONTEND=noninteractive

# Install base system dependencies with version pinning
RUN <<EOF
apt-get update
apt-get upgrade -y  # If you need an IMMUTABLE IMAGE, comment out the upgrade
apt-get install -y -q --no-install-recommends \
  ca-certificates='20*' \
  curl='7.81.*' \
  tzdata='2024*'

# Comprehensive cleanup
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# APP_ENV: Deployment environment
# Default: production
ENV APP_ENV="production"

# APP_PORT: Application port
# Default: 8080
ENV APP_PORT="8080"

# APP_USER: Non-root user for running the application
# Default: appuser
ENV APP_USER="appuser"

# Create non-root user
RUN <<EOF
groupadd -r "${APP_USER}" --gid=1000
useradd -r -g "${APP_USER}" --uid=1000 --home-dir=/app --shell=/sbin/nologin "${APP_USER}"
mkdir -p /app
chown -R "${APP_USER}:${APP_USER}" /app
EOF

WORKDIR /app

# =============================================================================
# DEVELOPMENT STAGE: For local development with hot reload
# =============================================================================
FROM base AS development

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Install development tools
RUN <<EOF
apt-get update
apt-get install -y -q --no-install-recommends \
  git='1:2.34.*' \
  vim='2:8.2.*'
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF

# Copy dependency files (for caching)
COPY --chown="${APP_USER}:${APP_USER}" package.json package-lock.json ./

# Install all dependencies (including dev)
USER "${APP_USER}"
RUN npm ci --include=dev

# Copy application source
COPY --chown="${APP_USER}:${APP_USER}" . .

EXPOSE "${APP_PORT}"
CMD ["npm", "run", "dev"]

# =============================================================================
# DEPENDENCIES STAGE: Install production dependencies
# =============================================================================
FROM base AS dependencies

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Copy dependency files
COPY package.json package-lock.json ./

# Install production dependencies
USER "${APP_USER}"
RUN npm ci --omit=dev --no-cache

# =============================================================================
# BUILDER STAGE: Build/compile application
# =============================================================================
FROM dependencies AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Install build dependencies if needed
USER root
RUN <<EOF
apt-get update
apt-get install -y -q --no-install-recommends \
  build-essential='12.9*' \
  python3='3.10.*'
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF

# Copy source code
USER "${APP_USER}"
COPY --chown="${APP_USER}:${APP_USER}" . .

# Build application
RUN npm run build

# =============================================================================
# TEST STAGE: Run tests during build
# =============================================================================
FROM builder AS test

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Install test dependencies
USER root
RUN <<EOF
apt-get update
apt-get install -y -q --no-install-recommends \
  pre-commit='2.17.*'
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF

# Run tests
USER "${APP_USER}"
RUN npm test

# Run pre-commit hooks if .pre-commit-config.yaml exists
RUN <<EOF
if [ -f .pre-commit-config.yaml ]; then
  pre-commit run --all-files
fi
EOF

# =============================================================================
# SECURITY-SCAN STAGE: Scan for vulnerabilities
# =============================================================================
FROM test AS security-scan

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

USER root

# Install Trivy for security scanning
RUN <<EOF
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
EOF

# Scan the filesystem
RUN trivy fs --severity HIGH,CRITICAL --exit-code 1 /app

# =============================================================================
# PRODUCTION STAGE: Minimal runtime image
# =============================================================================
FROM base AS production

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies (if any)
RUN <<EOF
apt-get update
apt-get upgrade -y  # If you need an IMMUTABLE IMAGE, comment out the upgrade
apt-get install -y -q --no-install-recommends \
  nodejs='12.22.*'
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF

# Copy only necessary artifacts from builder
COPY --from=dependencies --chown="${APP_USER}:${APP_USER}" /app/node_modules ./node_modules
COPY --from=builder --chown="${APP_USER}:${APP_USER}" /app/dist ./dist
COPY --from=builder --chown="${APP_USER}:${APP_USER}" /app/package.json ./

# Copy entrypoint script
COPY --chown="${APP_USER}:${APP_USER}" docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Switch to non-root user
USER "${APP_USER}"

# Document exposed port
EXPOSE "${APP_PORT}"

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:${APP_PORT}/health || exit 1

# Set entrypoint and default command
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["node", "dist/index.js"]
