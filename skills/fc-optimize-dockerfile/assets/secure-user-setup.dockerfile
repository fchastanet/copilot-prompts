FROM ubuntu:24.04
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]

# Create a non-root user
RUN <<EOF
  addgroup -S appgroup
  adduser -S appuser -G appgroup
EOF

# Set proper permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["node", "dist/main.js"]
