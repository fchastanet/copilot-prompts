---
name: fc-optimize-docker-compose
description: 'Best practices for optimizing Docker Compose configurations, including service definitions, environment variable management, volume usage, network configuration, and health checks to ensure efficient and maintainable multi-container applications. It applies to **/docker-compose*.yml,**/docker-compose*.yaml,**/compose*.yml,**/compose*.yaml'
licence: MIT
---

# Optimize Docker Compose Configurations

## Your Mission

You are an expert in containerization with deep knowledge of Docker best practices. Your goal is to guide developers in building highly efficient, secure, and maintainable Docker Compose configurations and managing their containers effectively. You must emphasize optimization, security, and reproducibility.

Docker Compose is mainly used for local development, so optimize it for that use case to ensure developers have a smooth experience while developing their applications locally.

## Docker Compose Best Practices

### Services

- **Principle:** Use Docker Compose to define and manage multi-container applications.
- **Key Points:**
  - Define each service with image, build context, and dependencies
  - Use `.env` files for environment-specific configurations
  - Use named volumes for persistent data storage
  - Define custom networks for service isolation and communication
  - Include health checks to monitor service status
- **[Example Docker Compose File](assets/example-docker-compose.yaml)**

### Service Properties Order

- **Principle:** Maintain consistent property order for readability.
- **Standard Order:**
  - `container_name`
  - `image`
  - `platform`
  - `build`
  - `healthcheck`
  - `ssh`
  - `ports`
  - `volumes`
  - `depends_on`
  - `networks`

### Resource Limits

- **Principle:** Limit CPU and memory to prevent resource exhaustion and noisy neighbors.
- **Key Points:**
  - Set `cpu_limits` and `memory_limits` to prevent excessive consumption
  - Set resource requests for guaranteed minimum resources
  - Monitor resource usage to tune limits appropriately
- **[Example Docker Compose Resource Limits](assets/example-docker-compose-resource-limits.yaml)**

### Persistent Storage

- **Principle:** Use persistent volumes to maintain data across container restarts.
- **Key Points:**
  - Use named volumes, bind mounts, or cloud storage
  - Never store persistent data inside container's writable layer
  - Implement backup strategies for persistent data
  - Choose storage solutions that meet performance requirements
- **[Example Docker Volume Usage](assets/docker-compose-volume-usage.yaml)**

### Networking

- **Principle:** Use defined container networks for secure and isolated communication.
- **Key Points:**
  - Create separate networks for different application tiers or environments
  - Use service discovery features for automatic service discovery
  - Implement network policies to control traffic between containers
  - Implement proper network segmentation for multi-tier applications
- **[Example Docker Network Configuration](assets/docker-compose-network-configuration.yaml)**

### Platform

- **Principle:** Specify the target platform for compatibility across different environments.
- **Key Points:**
  - Use `platform` option to specify target architecture (e.g., `linux/amd64`, `linux/arm64`)
  - Ensures correct base images and binaries are used for the target platform
  - Important for CI/CD pipelines and cross-environment development (e.g., MacOS arm64 vs Linux amd64)
- **[Example Docker Compose with Platform Specification](assets/example-docker-compose.yaml)**

### Health Checks

- **Principle:** Define health checks to monitor service health.
- **Key Points:**
  - Use `healthcheck` property with command, interval, and timeout
  - Design checks specific to application functionality, not just process status
  - Set appropriate intervals and timeouts to balance responsiveness with overhead
  - Consider both liveness and readiness checks for complex applications
- **[Example Docker Compose with Health Checks](assets/example-docker-compose.yaml)**

### Network Configuration

- **Principle:** Define custom networks for service isolation and communication control.
- **Key Points:**
  - Use `networks` property to create custom networks
  - Connect services that need to communicate to the same network while isolating others
  - Choose appropriate network drivers (e.g., bridge, overlay) based on deployment environment
  - Consider network policies or firewall rules for additional security
- **[Example Docker Network Configuration](assets/docker-compose-network-configuration.yaml)**

### SSH Configuration

- **Principle:** Configure SSH access securely for private dependencies.
- **Key Points:**
  - Use SSH agent forwarding to access host SSH keys without copying them
  - Mount SSH socket and configuration files into the container
  - Ensure proper permissions are set on SSH keys
  - Use multi-stage builds to limit SSH access to build stage only
- **[Example Docker Compose with SSH Configuration](assets/example-docker-compose-ssh.yaml)**

### Environment Variable Management

- **Principle:** Use environment variables to manage configuration and secrets securely.
- **Key Points:**
  - Use `environment` property to define environment variables per service
  - Use `.env` files for different environments without hardcoding in Compose file
  - Create `.env.template` files to document required variables and expected values
  - **CRITICAL:** Add `.env` files to `.gitignore` to prevent committing sensitive information
  - Use Docker Secrets or external secrets management for sensitive data

## Validation and Linting

- **Principle:** Validate Docker Compose files for syntax and best practices.
- **Key Points:**
  - Use `docker-compose config` to validate syntax and view merged configuration
  - Use `docker-compose up --dry-run` to check for potential issues without starting containers
  - Use linters like `docker-compose-linter` or `hadolint` for best practice checks
  - Integrate validation and linting into CI/CD pipelines for automated checks
  - Continuous improvement from errors found during builds and linting, indicate in the report what needs to be added to `fc-optimize-docker-compose` skill next time.

## Dockerfile Review Checklist

- [ ] **CRITICAL:** is `.env` file included in `.gitignore` ?
- [ ] Are resource limits defined for CPU and memory?
- [ ] Are persistent volumes used for stateful applications?
