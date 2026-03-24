FROM ubuntu:20.04

# REQUIRED: Set shell options for all RUN instructions
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Now all RUN instructions will:
# - Stop on first error (errexit)
# - Detect pipeline failures (pipefail)
# - Print each command (xtrace) for debugging
ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
  apt-get update
  apt-get install -y --no-install-recommends \
    curl
  curl --version
EOF

# If a command can fail intentionally:
RUN <<EOF
  some-optional-command || true
  required-command
EOF
