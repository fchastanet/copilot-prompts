# =============================================================================
# Heredoc Example: Multi-Command Build Process
# =============================================================================
# This example demonstrates downloading, compiling, and installing software
# with proper cleanup in a single layer using heredoc syntax.
# =============================================================================

FROM ubuntu:22.04

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

RUN <<EOF
# Download, compile, and install application
wget -O /tmp/app.tar.gz https://example.com/app-1.2.3.tar.gz
tar -xzf /tmp/app.tar.gz -C /opt/
cd /opt/app-1.2.3
./configure --prefix=/usr/local
make -j$(nproc)
make install

# Cleanup build artifacts
cd /
rm -rf /tmp/app.tar.gz /opt/app-1.2.3
EOF
