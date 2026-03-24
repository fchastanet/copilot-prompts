#!/bin/bash

# This script is intended to be used as an entrypoint for a Docker container.
# It sets up signal handling for graceful shutdowns and executes the main application passed as arguments.

# Enable strict error handling and command tracing for debugging purposes
set -o errexit -o pipefail -x

# This is an example entrypoint script that demonstrates best practices for handling signals and executing the main application.
# It ensures that the application can receive signals properly for graceful shutdowns.
# Function to handle termination signals
term_handler() {
    echo "Termination signal received. Shutting down gracefully..."
    # Perform any cleanup tasks here if necessary
    exit 0
}
# Trap termination signals (SIGTERM, SIGINT)
trap 'term_handler' SIGTERM SIGINT

# Execute the main application (CMD instruction in Dockerfile will provide the command and arguments)
exec "$@"
