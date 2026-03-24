# Set default values
ENV NODE_ENV=production
ENV PORT=3000
ENV LOG_LEVEL=info

# Use ARG for build-time variables
ARG BUILD_VERSION
ENV APP_VERSION=${BUILD_VERSION:-unknown}

# REQUIRED for apt-get operations
ARG DEBIAN_FRONTEND=noninteractive

# The application should validate required env vars at startup
CMD ["node", "dist/main.js"]
