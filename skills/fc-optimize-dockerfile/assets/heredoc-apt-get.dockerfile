# =============================================================================
# Heredoc Example: Apt-Get Package Installation
# =============================================================================
# This example demonstrates the proper way to install system packages using
# heredoc syntax with version pinning and comprehensive cleanup.
# =============================================================================

FROM ubuntu:22.04

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Build argument for non-interactive apt-get
ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
# Install system dependencies with version pinning
apt-get update
apt-get upgrade -y  # If you need an IMMUTABLE IMAGE, comment out the upgrade
apt-get install -y -q --no-install-recommends \
  apache2='2.4.*' \
  curl='7.68.*' \
  git='1:2.25.*' \
  wget='1.20.*'

# Comprehensive cleanup
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /usr/share/{doc,man,locale}/
EOF
