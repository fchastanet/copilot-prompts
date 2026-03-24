# dockerfile's stages inheritance diagram:
# - BASE IMAGE python:3.13-trixie
#   - STAGE python-ai-api-builder: install all dependencies to system Python (torch, FastAPI, etc.)
#   - STAGE python-ai-api-base: copy site-packages from python-ai-api-builder
#     - STAGE python-ai-api-test-runner: run tests, create test marker file
#   - STAGE python-ai-api-dev: install dev dependencies
#   - STAGE python-ai-api-prod: copy test marker from test-runner, copy source code, set entrypoint

######################################################################################
#####                     python-ai-api-builder                                   ####
######################################################################################
# Builder stage: installs dependencies to system Python
# Uses full Debian image for build tools (git, compilers, etc.)
FROM python:3.13-trixie AS python-ai-api-builder

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# ensure image is rebuilt every month for security updates (cache busting)
ARG UPDATE_DATE
ARG DEBIAN_FRONTEND=noninteractive

# Runtime environment for Python in builder
# - PYTHONDONTWRITEBYTECODE=1: Prevent .pyc files (cleaner, reduce image size)
# - PIP_NO_CACHE_DIR=on: Don't store pip cache (reduces image size, never reused in container)
# - PIP_DISABLE_PIP_VERSION_CHECK=on: Skip pip version check (faster, cleaner logs)
# - PIP_DEFAULT_TIMEOUT=100: Reasonable timeout for pip downloads
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

RUN <<EOF
    apt-get update
    # Apply latest security updates
    # https://pythonspeed.com/articles/security-updates-in-docker/
    apt-get upgrade -y
    apt-get install -y -q --no-install-recommends git

    # Upgrade pip
    pip install --no-compile --no-cache-dir --upgrade pip

    # Cleanup to reduce layer size
    apt-get autoremove -y
    apt-get -y clean
    rm -rf /root/.cache /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
EOF

# Install AI dependencies (torch, dspy, etc. - ~3GB)
# Copy only what's needed to maximize cache hits
COPY requirements/requirements-ai.txt ./requirements-ai.txt
RUN <<EOF
    # Install torch without GPU support to reduce image size (CPU-only wheel is ~200MB vs 2GB+ for GPU)
    # Using --extra-index-url so PyPI remains primary, but torch comes from CPU-only index
    pip install --no-compile --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cpu \
        -r requirements-ai.txt

    # Clean up any residual cache/temp files in same layer
    find /usr/local -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
    rm -rf /root/.cache /tmp/*
EOF

# Install base dependencies (FastAPI, MongoDB, etc.)
COPY requirements/requirements-base.txt ./requirements-base.txt
RUN <<EOF
    pip install --no-compile --no-cache-dir -r requirements-base.txt

    # Clean up any residual cache/temp files in same layer
    find /usr/local -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
    rm -rf /root/.cache /tmp/*
EOF

######################################################################################
#####                     python-ai-api-base                                      ####
######################################################################################
# Base runtime stage: slim image with Python packages from builder, no source code yet
# All application stages inherit from this
FROM python:3.13-slim-trixie AS python-ai-api-base

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Metadata labels following OCI spec
LABEL org.opencontainers.image.title="Phoenix AI API"
LABEL org.opencontainers.image.description="FastAPI-based AI content recommendation service"
LABEL org.opencontainers.image.vendor="CrossKnowledge"
LABEL org.opencontainers.image.source="https://github.com/CrossKnowledge/phoenix-ai"

# Build arguments
ARG UPDATE_DATE
ARG DEBIAN_FRONTEND=noninteractive

# Production runtime environment
# - PYTHONDONTWRITEBYTECODE=0: Allow .pyc files for faster startup (skip compilation on import)
# - PYTHONUNBUFFERED: Real-time log output (required for container logging)
# - PYTHONHASHSEED=random: Security - prevents hash collision DoS attacks
# - PIP_NO_CACHE_DIR=on: Don't create pip cache (not needed at runtime, reduces image size)
ENV PYTHONDONTWRITEBYTECODE=0 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=on \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PYTHONPATH="/usr/src/app"

# Copy Python packages from builder (3.3GB layer - shared across all stages)
# Packages are installed to system Python (/usr/local/lib/python3.13/site-packages)
COPY --from=python-ai-api-builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=python-ai-api-builder /usr/local/bin /usr/local/bin

# Download Amazon DocumentDB CA cert (using ADD is appropriate here per Docker docs)
# ADD with URL is optimal: single layer, automatic extraction, cached by URL content
ADD --chmod=644 https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem /cert/global-bundle.pem

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /usr/src/app

######################################################################################
#####                     python-ai-api-test-runner                               ####
######################################################################################
# Test runner stage: runs tests during build, creates test artifact
# This stage is NOT in the production lineage but prod depends on it via COPY --from
FROM python-ai-api-base AS python-ai-api-test-runner

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Install test dependencies (small layer)
COPY requirements/requirements-test.txt ./requirements/requirements-test.txt
RUN <<EOF
    pip install --no-compile --no-cache-dir -r requirements/requirements-test.txt
    rm -rf /root/.cache /tmp/*
EOF

# Copy source code for testing
COPY . .

# Run tests and create test marker file
# If tests fail, build fails and prod stage cannot be built
# Note: Coverage reports are generated but not persisted in prod image
RUN <<EOF
    pytest --junitxml=/tmp/test-results/junit.xml \
           --cov=./ \
           --cov-report=xml:/tmp/test-results/coverage.xml \
           --cov-report=term \
           --cov-fail-under=80
    echo "$(date -Iseconds) - Tests passed" > /tmp/test-results/tests-passed.txt
EOF

######################################################################################
#####                     python-ai-api-dev                                       ####
######################################################################################
# Development stage: for local development with hot reload
# Overrides some base ENV variables for better dev experience
FROM python-ai-api-base AS python-ai-api-dev

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Override production ENV for development
# - PYTHONHASHSEED=0: Reproducible behavior for debugging (not random)
# - PIP_NO_CACHE_DIR=off: Enable pip cache for interactive package installs in dev container
# - PYTHONDONTWRITEBYTECODE=1: Prevent .pyc clutter (code changes frequently in dev)
ENV PYTHONHASHSEED=0 \
    PIP_NO_CACHE_DIR=off \
    PYTHONDONTWRITEBYTECODE=1

# Install test dependencies first (for running tests locally)
COPY requirements/requirements-test.txt ./requirements/requirements-test.txt
RUN <<EOF
    pip install --no-compile --no-cache-dir -r requirements/requirements-test.txt
EOF

# Install dev dependencies (debugpy, etc.)
COPY requirements/requirements-dev.txt ./requirements/requirements-dev.txt
RUN <<EOF
    pip install --no-compile --no-cache-dir -r requirements/requirements-dev.txt
EOF

# Note: Dev stage intentionally keeps pip cache (PIP_NO_CACHE_DIR=off)
# for faster interactive package installs during development

# Note: Source code is mounted as volume in dev, not copied
# This allows hot reload without rebuild

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload", "--reload-dir", "/usr/src/app", "--no-server-header"]

######################################################################################
#####                     python-ai-api-prod                                      ####
######################################################################################
# Production stage: depends on tests passing but doesn't include test layers
# Uses COPY --from=test-runner to create build dependency without inheriting test layers
FROM python-ai-api-base AS python-ai-api-prod

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Verify tests passed by copying test marker (build fails if tests failed)
# This creates the dependency without including test layer bloat
COPY --from=python-ai-api-test-runner /tmp/test-results/tests-passed.txt /tmp/tests-passed.txt

# Copy source code with proper ownership
COPY --chown=appuser:appuser . .

# Display test marker for build logs verification
RUN cat /tmp/tests-passed.txt && rm /tmp/tests-passed.txt

# Switch to non-root user for security
USER appuser

# Health check for container orchestration
# Checks both HTTP endpoint and MongoDB connectivity
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/healthz').read()" || exit 1

# Define entrypoint and default command
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--no-server-header"]
