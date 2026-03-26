# =============================================================================
# Heredoc Example: Configuration File Creation
# =============================================================================
# This example demonstrates creating configuration files directly in the
# Dockerfile using heredoc syntax.
# =============================================================================

FROM ubuntu:22.04

# Configure shell for proper error handling and debugging
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Create directory for configuration
RUN mkdir -p /etc/myapp

# Create configuration file using heredoc
RUN <<EOF cat > /etc/myapp/config.toml
[server]
host = "0.0.0.0"
port = 8080

[database]
connection_pool = 10
timeout = 30
EOF
