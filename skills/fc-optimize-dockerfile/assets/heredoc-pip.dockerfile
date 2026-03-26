# =============================================================================
# Heredoc Example: Python Pip Package Installation
# =============================================================================
# This example demonstrates the proper way to install Python packages using
# heredoc syntax without caching and with version pinning.
# =============================================================================

FROM python:3.11-slim

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

RUN <<EOF
# Install Python dependencies without cache
pip install --no-cache-dir --no-compile \
  django==4.2.* \
  flask==2.3.* \
  requests==2.31.* \
  sqlalchemy==2.0.*

# Remove pip cache (redundant with --no-cache-dir but ensures cleanup)
rm -rf /root/.cache/pip
EOF
