# =============================================================================
# ENVIRONMENT VARIABLES DOCUMENTATION TEMPLATE
# =============================================================================
# This template demonstrates the proper way to document environment variables
# in your Dockerfile with clear descriptions, defaults, examples, and
# required status.
# =============================================================================

FROM ubuntu:22.04

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
# Each variable is documented with:
# - Description: Purpose and usage
# - Default: Default value if not overridden
# - Example: Sample values for different scenarios
# - Required: Whether the variable must be set
# =============================================================================

# -----------------------------------------------------------------------------
# Application Configuration
# -----------------------------------------------------------------------------

# APP_ENV: Deployment environment (development/staging/production)
# Default: production
# Required: No
# Example: APP_ENV=staging
ENV APP_ENV="production"

# APP_PORT: Port the application listens on
# Default: 8080
# Required: No
# Example: APP_PORT=3000
ENV APP_PORT="8080"

# APP_LOG_LEVEL: Logging verbosity (debug/info/warning/error)
# Default: info
# Required: No
# Example: APP_LOG_LEVEL=debug
ENV APP_LOG_LEVEL="info"

# -----------------------------------------------------------------------------
# Database Configuration
# -----------------------------------------------------------------------------

# DB_HOST: Database server hostname or IP address
# Default: localhost
# Required: Yes (in production)
# Example: DB_HOST=postgres.example.com
ENV DB_HOST="localhost"

# DB_PORT: Database server port
# Default: 5432
# Required: No
# Example: DB_PORT=5433
ENV DB_PORT="5432"

# DB_NAME: Database name to connect to
# Default: myapp
# Required: Yes
# Example: DB_NAME=production_db
ENV DB_NAME="myapp"

# DB_POOL_SIZE: Maximum number of database connections
# Default: 10
# Required: No
# Example: DB_POOL_SIZE=20
ENV DB_POOL_SIZE="10"

# -----------------------------------------------------------------------------
# Security Configuration
# -----------------------------------------------------------------------------

# API_RATE_LIMIT: Maximum requests per minute per IP
# Default: 100
# Required: No
# Example: API_RATE_LIMIT=200
ENV API_RATE_LIMIT="100"

# CORS_ORIGINS: Allowed CORS origins (comma-separated)
# Default: *
# Required: Yes (in production)
# Example: CORS_ORIGINS=https://app.example.com,https://admin.example.com
ENV CORS_ORIGINS="*"

# -----------------------------------------------------------------------------
# Feature Flags
# -----------------------------------------------------------------------------

# FEATURE_NEW_UI: Enable experimental UI features
# Default: false
# Required: No
# Example: FEATURE_NEW_UI=true
ENV FEATURE_NEW_UI="false"

# -----------------------------------------------------------------------------
# Performance Tuning
# -----------------------------------------------------------------------------

# WORKER_PROCESSES: Number of worker processes
# Default: auto (number of CPU cores)
# Required: No
# Example: WORKER_PROCESSES=4
ENV WORKER_PROCESSES="auto"

# CACHE_TTL: Cache time-to-live in seconds
# Default: 3600 (1 hour)
# Required: No
# Example: CACHE_TTL=7200
ENV CACHE_TTL="3600"
