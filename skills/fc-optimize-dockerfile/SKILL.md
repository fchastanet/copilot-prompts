---
name: fc-optimize-dockerfile
description: 'Comprehensive best practices for creating optimized, secure, and efficient Docker images and managing containers. Covers multi-stage builds, image layer optimization, security scanning, and runtime best practices. It applies to **/Dockerfile,**/Dockerfile.*,**/*.dockerfile,**/*Dockerfile'
licence: MIT
---

# Containerization & Docker Best Practices

## Your Mission

You are an expert in containerization with deep knowledge of Docker best practices. Your goal is to guide developers in building highly efficient, secure, and maintainable Docker images and managing their containers effectively. You must emphasize optimization, security, and reproducibility.

## Core Principles of Containerization

### Immutability

- **Principle:** Once a container image is built, it should not change. Any changes should result in a new image.
- **Implementation:**
  - Create new images for every code change or configuration update; never modify running containers in production
  - Use semantic versioning for image tags (e.g., `v1.2.3`); avoid `master` for production
  - Implement automated image builds triggered by code changes
  - Treat container images as versioned artifacts stored in registries
- **Pro Tip:** Immutable images enable instant rollbacks and consistent environments across all stages.

### Portability

- **Principle:** Containers should run consistently across different environments (local, cloud, on-premise) without modification.
- **Implementation:**
  - Design self-contained Dockerfiles; externalize all environment-specific configurations
  - Use environment variables for runtime configuration with sensible defaults
  - Include all dependencies explicitly; avoid reliance on host packages
  - Use multi-platform base images when targeting multiple architectures
  - Implement configuration validation at startup to fail fast

### Isolation

- **Principle:** Containers provide process and resource isolation, preventing interference between applications.
- **Implementation:**
  - Run a single process (or clear primary process) per container
  - Use container networking for inter-container communication; avoid host networking
  - Implement resource limits to prevent resource exhaustion
  - Use named volumes for persistent data over bind mounts
- **Pro Tip:** Don't break isolation for convenience; it's the foundation of container security.

### Efficiency & Small Images

- **Principle:** Smaller images are faster to build, push, pull, and consume fewer resources.
- **Implementation:**
  - Use multi-stage builds and minimal base images as default
  - Exclude unnecessary tools, debugging utilities, or dev dependencies from production images
  - Perform regular image size analysis and optimization
- **Pro Tip:** Image size optimization is ongoing; regularly review and optimize.

## Dockerfile Best Practices

### SHELL Instruction

- **Principle:** Configure shell behavior for all RUN instructions to ensure proper error handling and debugging.
- **Implementation:**
  - **ALWAYS include after each FROM:** `SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "xtrace", "-c"]`
  - `pipefail`: Pipeline failures detected (exit from first failed command)
  - `errexit`: Exit immediately on any failure
  - `xtrace`: Print each command before execution for debugging
- **Benefit:** Dramatically improves error visibility; xtrace shows exactly which command failed.
- **[SHELL usage Example (MANDATORY SHELL Configuration)](assets/shell-usage.dockerfile)**

### Bash script best practices

- **Principle:** When using shell scripts in RUN instructions or entrypoints, use `fc-optimize-shell-scripts` skill.

### Multi-Stage Builds (The Golden Rule)

- **Principle:** Use multiple `FROM` instructions in a single Dockerfile to separate build-time dependencies from runtime dependencies.
- **Implementation:**
  - Always use multi-stage for compiled languages (Go, Java, .NET, C++) and when build tools are heavy (Node.js/Python)
  - Name stages descriptively (`AS build`, `AS test`, `AS production`)
  - Add stage comment headers to clearly separate stages
  - Use `COPY --from=<stage>` to transfer only necessary artifacts
  - Put longest/heaviest builds first, frequently changing content last (optimize caching)
  - Include stage diagram at Dockerfile beginning showing inheritance/dependencies
  - Use different base images for build vs runtime when appropriate
  - Optimize by removing unnecessary stages or adding intermediate caching stages
- **Benefit:** Significantly reduces final image size and attack surface.
- **[Multi-Stage Build Example (Advanced Multi-Stage with Testing)](assets/multi-stage-example.dockerfile)**

#### Development stage

Use `askQuestions` tool to ask if the user wants to include a development stage in their Dockerfile for local development, and provide guidance if they choose to do so.

#### Test stage

Use `askQuestions` tool to ask if the user wants to include a test stage in their Dockerfile for running tests during the build process, and provide guidance if they choose to do so.

- **Implementation:**
  - Run unit tests, integration tests, or static analysis during build
  - Generate test reports/artifacts for debugging or CI/CD
  - Use caching to speed up test runs in dev; always run in CI/CD
  - If `.pre-commit-config.yaml` exists, run `pre-commit run --all-files` to enforce quality checks

#### Security scanning stage

Use `askQuestions` tool to ask if the user wants to include a security scanning stage in their Dockerfile for scanning the image for vulnerabilities during the build process, and provide guidance if they choose to do so.

- **Implementation:**
  - Integrate security scanning tools (Trivy, Clair, Snyk) into build
  - Configure build to fail on critical vulnerabilities
  - Regularly scan registry images for new vulnerabilities
  - Use as security gate in CI/CD pipelines

#### Production stage

- **Principle:** The final stage should be as minimal as possible, containing only the necessary runtime dependencies and application artifacts.
- **Implementation:**
  - Use minimal base image to reduce attack surface
  - Include only runtime dependencies, exclude build tools and dev dependencies
  - Copy only necessary application artifacts from build stage
  - Apply security hardening (non-root user, security updates)

### Choose the Right Base Image

- **Principle:** Select official, stable, and minimal base images that meet your application's requirements.
- **Implementation:**
  - **CRITICAL: NEVER use `latest` tag**; always specify exact versions (e.g., `ubuntu:20.04`)
  - Prefer official images from Docker Hub or cloud providers
  - Use minimal variants (`slim`, not alpine for production due to musl libc issues)
  - Use language-specific official images (e.g., `python:3.9-slim-buster`, `openjdk:17-jre-slim`)
  - **ALWAYS apply security updates** with `apt-get upgrade -y` after choosing base
  - Regularly update base images for security patches
- **Pro Tip:** Start with the smallest image meeting your needs for fewer vulnerabilities and faster downloads.

### Optimize Image Layers

- **Principle:** Each instruction in a Dockerfile creates a new layer. Leverage caching effectively to optimize build times and image size.
- **Implementation:**
  - Order instructions from least to most frequently changing (dependencies before source code)
  - **CRITICAL: avoid `&&`**; use `set -o errexit` for reliable error detection
  - Clean up temporary files in same RUN command (e.g., `rm -rf /var/lib/apt/lists/*`)
  - Use heredoc (`<<EOF`) to group commands with proper error handling
  - List each package on separate line, alphabetically ordered
- **[Example (Advanced Layer Optimization)](assets/advanced-layer-optimization.dockerfile)**

### Advanced Image Size Optimization

- **Principle:** Configure package managers to exclude unnecessary files and disable caching for maximum space efficiency.
- **Implementation:**
  - Configure dpkg to exclude man pages, documentation, locales during package installation
  - Configure apt to not store cache (makes `apt-get clean` unnecessary)
  - Configurations persist across all package installations in derived images
- **Benefit:** 40MB+ savings with persistent configuration for multi-stage builds.
- **[Example (Maximum Space Optimization)](assets/maximum-space-optimization.dockerfile)**

#### Ubuntu based images

- After Apt install, still remove existing cache with `apt-get clean`
      and `rm -rf /var/cache/apt/archives /usr/share/{doc,man,locale}/`.

#### Alpine based images

- Use `apk --no-cache` to avoid caching during package installation.
- Clean up apk cache with `rm -rf /var/cache/apk/*` after installation.
- Use `--virtual` to create a virtual package for build dependencies and remove it after installation to reduce image size.
- Example: `apk --no-cache --virtual .build-deps add build-base && apk del .build-deps`
- Alpine images can grow significantly when adding common packages, so consider using `slim` variants or other minimal base images for production.

#### Python

- Use `python:3.x-slim` as the base image for production.
- No need of `venv` or `virtualenv` inside the container, as the container itself provides isolation.
- Use `pip install --no-compile --no-cache-dir` to avoid caching and bytecode compilation.
- Use `ENV PIP_NO_CACHE_DIR=off` to disable pip caching by default except for dev stages.
- Use `ENV PYTHONDONTWRITEBYTECODE=1` to prevent creation of .pyc files except for dev stages.
- Use `ENV PYTHONUNBUFFERED=1` to disable output buffering for better logging.
- Use `ENV PYTHONHASHSEED=random` to prevent hash collision DoS attacks, `ENV PYTHONHASHSEED=0` for dev stages.

#### Node.js

- Use `node:xx-slim` as the base image for production.
- Use `npm ci --no-cache` to avoid caching during npm installs except for dev stages.
- Use `npm ci` instead of `npm install` for reproducible builds, as it installs exactly what's in `package-lock.json`.

### Use `.dockerignore` Effectively

- **Principle:** Exclude unnecessary files from the build context to speed up builds and reduce image size.
- **Implementation:**
  - Always create and maintain comprehensive `.dockerignore` file
  - Common exclusions: `.git`, `node_modules` (if installed in container), host build artifacts, docs, tests
  - Exclude sensitive files (`.env`, `.git`) to prevent accidental inclusion
  - Review regularly as project evolves
- Pick relevant examples:
- **[Example (python)](assets/dockerignore-python)**
- **[Example (dotnet)](assets/dockerignore-dotnet)**
- **[Example (node)](assets/dockerignore-node)**
- **[Example (php)](assets/dockerignore-php)**
- **Pro Tip:** Test patterns with `docker build --no-cache -t test .` using this Dockerfile:

```dockerfile
From ubuntu
COPY . /app
RUN find /app
```

### Minimize `COPY` Instructions

- **Principle:** Copy only what is necessary, when it is necessary, to optimize layer caching and reduce image size.
- **Implementation:**
  - Use specific paths (`COPY src/ ./src/`) instead of entire directory (`COPY . .`) when possible
  - Copy dependency files (`package.json`, `requirements.txt`) before source code for better layer caching
  - Copy only necessary files for each stage in multi-stage builds
  - Use `.dockerignore` to exclude files that shouldn't be copied
- **[Example (Optimized COPY Strategy)](assets/optimized-copy-strategy.dockerfile)**

### Define Default User and Port

- **Principle:** Run containers with a non-root user for security and expose expected ports for clarity.
- **Implementation:**
  - Use `USER <non-root-user>` to run application as non-root (least privilege principle)
  - Create dedicated user in Dockerfile rather than using existing one
  - Use `EXPOSE` to document ports (doesn't publish them)
  - Ensure proper file permissions for non-root user
- **[Example (Secure User Setup)](assets/secure-user-setup.dockerfile)**

### Use `CMD` and `ENTRYPOINT` Correctly

- **Principle:** Define the primary command that runs when the container starts, with clear separation between the executable and its arguments.
- **Implementation:**
  - Use `ENTRYPOINT` for executable, `CMD` for arguments (`ENTRYPOINT ["/app/start.sh"]`, `CMD ["--config", "prod.conf"]`)
  - For simple execution, `CMD ["executable", "param1"]` is sufficient
  - Prefer exec form (`["command", "arg1"]`) over shell form for proper signal handling
  - Consider shell scripts as entrypoints for complex startup logic
- **Pro Tip:** Exec form ensures application receives signals properly for graceful shutdowns.
- **[Example Proper entrypoint.sh](assets/entrypoint.sh)**

### Environment Variables for Configuration

- **Principle:** Externalize configuration using environment variables or mounted configuration files to make images portable and configurable.
- **Implementation:**
  - Use `ENV` for defaults; allow runtime overriding for varying configurations (databases, APIs, feature flags)
  - **ALWAYS use `ARG DEBIAN_FRONTEND=noninteractive`** before apt-get operations
  - Use `ARG` for build-time variables; `ENV` for runtime configuration
  - Validate required environment variables at startup to fail fast
  - Never hardcode secrets in Dockerfile environment variables
  - Add comments for important environment variables to explain their purpose and usage
- **[Example (Environment Variable Best Practices)](assets/environment-variable-best-practices.dockerfile)**

### Package Management Best Practices

- **Principle:** Install packages with strict version control, proper ordering, and comprehensive security updates.
- **Implementation:**
  - **MANDATORY: Include `apt-get upgrade -y`** after `apt-get update` for security patches ([reference](https://pythonspeed.com/articles/security-updates-in-docker/))
      Add comment: `# If you need an IMMUTABLE IMAGE, comment out the upgrade`
  - **ALWAYS specify package versions** with wildcards (e.g., `apache2='2.4.*'` for patch updates, blocking major versions)
  - List packages alphabetically, one per line, with proper quoting
  - Use `apt-get install -y -q --no-install-recommends` for minimal installations
  - Include comprehensive cleanup in same RUN command: `apt-get autoremove -y`, `apt-get clean`, remove cache dirs
  - Note: Some packages use epoch notation (e.g., `redis-tools='5:5.*'`)
- **Benefit:** Reproducible builds with security updates, smaller size, better maintainability.
- **[Example (Complete Package Management)](assets/complete-package-management.dockerfile)**

## Container Security Best Practices

### Non-Root User

- **Principle:** Running containers as `root` is a significant security risk and should be avoided in production.
- **Implementation:**
  - Always define non-root `USER` in Dockerfile; create dedicated user for application
  - Ensure minimum necessary permissions for the user
  - Use `USER` directive early to ensure subsequent operations run as non-root
- **[Example (Secure User Creation)](assets/secure-user-creation.dockerfile)**

### Minimal Base Images

- **Principle:** Smaller images mean fewer packages, thus fewer vulnerabilities and a reduced attack surface.
- **Implementation:**
  - Prioritize `slim` or `distroless` images over full distributions
  - Avoid `alpine` for production (musl libc compatibility issues; size grows with common packages)
  - Regularly review base image vulnerabilities using security scanning tools
  - Use language-specific minimal images (e.g., `openjdk:17-jre-slim` instead of `openjdk:17`)
  - Stay updated with latest minimal base image versions

### Static Analysis Security Testing (SAST) for Dockerfiles

- **Principle:** Scan Dockerfiles for security misconfigurations and known vulnerabilities before building images.
- **Implementation:**
  - Integrate `hadolint` (Dockerfile linting) and `Trivy`/`Clair`/`Snyk Container` (vulnerability scanning) into CI pipeline
  - Set up automated scanning for both Dockerfiles and built images
  - Fail builds if critical vulnerabilities found in base images
  - Regularly scan registry images for newly discovered vulnerabilities
- **[Example (Security Scanning in CI)](assets/security-scanning-ci.yaml)**

### Image Signing & Verification

Use `askQuestions` tool to ask if the user wants to implement image signing and verification in their pipeline, and provide guidance if they choose to do so.

- **Principle:** Ensure images haven't been tampered with and come from trusted sources.
- **Implementation:**
  - Use Notary, Docker Content Trust, or Cosign for signing/verifying images
  - Implement image signing in CI/CD pipeline for all production images
  - Set up trust policies preventing unsigned images from running
- **Example (Image Signing with Cosign):**

```bash
# Sign an image
cosign sign -key cosign.key myregistry.com/myapp:v1.0.0

# Verify an image
cosign verify -key cosign.pub myregistry.com/myapp:v1.0.0
```

### Limit Capabilities & Read-Only Filesystems

- **Principle:** Restrict container capabilities and ensure read-only access where possible to minimize the attack surface.
- **Implementation:**
  - Use `CAP_DROP` to remove unnecessary capabilities (e.g., `NET_RAW`, `SYS_ADMIN`)
  - Mount read-only volumes for sensitive data and configuration files
  - Use security profiles and policies when available in container runtime
- **Examples:**
  - Capability Restrictions: `RUN setcap -r /usr/bin/node`
  - Read-Only Filesystem: `docker run --read-only myapp:latest`
  - Seccomp Profile: `docker run --security-opt seccomp=seccomp-profile.json myapp:latest`
  - AppArmor Profile: `docker run --security-opt apparmor=custom-profile myapp:latest`
  - Capabilities Drop: `docker run --cap-drop=ALL --security-opt=no-new-privileges myapp`
- **Pro Tip:** Defense in depth is key. Use multiple layers of security controls.

### Optimize COPY logic

- **Principle:** Be mindful of copying files in layers to maximize caching and minimize image size. Avoid copying unnecessary files or secrets.
- **Implementation:**
  - Use specific paths in `COPY` to avoid copying entire directories when not needed
  - Leverage `.dockerignore` to exclude files that shouldn't be copied
  - Avoid copying secrets or sensitive files; use build arguments or secrets management instead
  - Copy dependency files (e.g., `package.json`, `requirements.txt`) before source code for better caching
  - Install in separated layers prod, tests, dev dependencies, and copy only necessary files for each layer/stage
  - Use multi-stage builds to copy only necessary artifacts to final image
- **Anti-pattern:** `COPY . .` without a proper `.dockerignore` can lead to large images and security risks if sensitive files are included.

### No Sensitive Data in Image Layers

- **Principle:** Never include secrets, private keys, or credentials in image layers as they become part of the image history.
- **Implementation:**
  - Use build arguments (`--build-arg`) for temporary build-time data (avoid sensitive info)
  - Use secrets management solutions for runtime (Kubernetes Secrets, Docker Secrets, HashiCorp Vault)
  - Scan images for accidentally included secrets
  - Use multi-stage builds to avoid including build-time secrets in final image
- **Anti-pattern:** `ADD secrets.txt /app/secrets.txt`

### Health Checks (Liveness & Readiness Probes)

- **Principle:** Ensure containers are running and ready to serve traffic by implementing proper health checks.
- **Implementation:**
  - Define `HEALTHCHECK` instructions in Dockerfiles (critical for orchestration systems)
  - Design health checks specific to application that check actual functionality
  - Use appropriate intervals and timeouts balancing responsiveness with overhead
  - Consider both liveness and readiness checks for complex applications
- **[Example Comprehensive Health Check](assets/example-comprehensive-health-check.dockerfile)**

## Container Runtime & Orchestration Best Practices

### Logging & Monitoring

- **Principle:** Collect and centralize container logs and metrics for observability and troubleshooting.
- **Implementation:**
  - Use standard logging output (`STDOUT`/`STDERR`) for container logs
  - Integrate with log aggregators (Fluentd, Logstash, Loki) and monitoring tools (Prometheus, Grafana)
  - Implement structured logging (JSON) in applications
  - Set up log rotation and retention policies

### Self-Testing stage

- **Principle:** Include a testing stage in your multi-stage builds to run tests and validate the image before deployment.
- **Implementation:**
  - Add test stage in multi-stage builds for running tests (unit, integration, security)
  - Include necessary testing tools and dependencies in test stage
  - Run tests automatically during build; fail build if tests fail
  - Optionally copy test results to production stage for validation
- **[Example Multi-Stage Build with Testing](assets/maximum-space-optimization.dockerfile)**

## Dockerfile Review Checklist

- [ ] **CRITICAL:** Is SHELL instruction present with `-o pipefail -o errexit -o xtrace` options?
- [ ] **CRITICAL:** Are multi-line `RUN` commands using Heredoc (`<<EOF`) for better readability and maintainability?
- [ ] **CRITICAL:** Is `apt-get upgrade -y` included after `apt-get update`?
- [ ] **CRITICAL:** Are all packages specified with version wildcards (e.g., `'2.4.*'`)?
- [ ] **CRITICAL:** Is base image version pinned (no `latest` tag)?
- [ ] **CRITICAL:** Have you run `docker build --no-cache .` to verify the build process and caching behavior?
- [ ] **CRITICAL:** ensure subsequent RUN instructions are merged into a single layer with proper cleanup to optimize image size.
- [ ] **CRITICAL:** is `.env` file included in `.gitignore` ?
- [ ] **CRITICAL:** Is dependency files (e.g., `package.json`, `requirements.txt`) copied before source code for better caching?
- [ ] **CRITICAL:** Is stages diagram included at the beginning of the Dockerfile to illustrate stage dependencies?
- [ ] **CRITICAL:** Is `SHELL` instruction included after each `FROM` to ensure proper error handling and debugging?
- [ ] Is `ARG DEBIAN_FRONTEND=noninteractive` set before apt-get operations?
- [ ] Are packages listed alphabetically, one per line?
- [ ] Is a multi-stage build used if applicable (compiled languages, heavy build tools)?
- [ ] Is a minimal, specific base image used (e.g., `slim`, versioned)?
- [ ] Are layers optimized (combining `RUN` commands, cleanup in same layer)?
- [ ] Is a `.dockerignore` file present and comprehensive?
- [ ] Are `COPY` instructions specific and minimal?
- [ ] Is dpkg/apt configuration added for doc/cache exclusion (for maximum optimization)?
- [ ] Is comprehensive cleanup included (`apt-get autoremove`, remove lists, tmp, docs)?
- [ ] Is a non-root `USER` defined for the running application?
- [ ] Is the `EXPOSE` instruction used for documentation?
- [ ] Is `CMD` and/or `ENTRYPOINT` used correctly?
- [ ] Are sensitive configurations handled via environment variables (not hardcoded)?
- [ ] Is a `HEALTHCHECK` instruction defined?
- [ ] Are there any secrets or sensitive data accidentally included in image layers?
- [ ] Are there static analysis tools (Hadolint, Trivy) integrated into CI?
- [ ] Has `hadolint` been run on the Dockerfile?

## Validation and Linting

- **Principle:** Validate Dockerfiles for syntax and best practices before building images.
- **Implementation:**
  - Use `hadolint` for Dockerfile linting and best practice checks
  - Use `docker build --no-cache` to verify the build process and caching behavior
  - Analyze image size with `docker images` and `docker history` to identify optimization opportunities
  - Integrate validation and linting into CI/CD pipelines for automated checks
  - Continuous improvement from errors found during builds and linting, indicate in the report what needs to be added to `fc-optimize-dockerfile` skill next time.

## Troubleshooting Docker Builds & Runtime

### Large Image Size

- Review layers for unnecessary files. Use `docker history <image>`.
- Implement multi-stage builds.
- Use a smaller base image.
- Optimize `RUN` commands and clean up temporary files.
- Use `.dockerignore` to exclude unnecessary files from the build context.
- Analyze library size and consider alternatives if they are too large.

### Slow Builds

- Leverage build cache by ordering instructions from least to most frequent change.
- Use `.dockerignore` to exclude irrelevant files.
- Use `docker build --no-cache` for troubleshooting cache issues.

### Container Not Starting/Crashing

- Check `CMD` and `ENTRYPOINT` instructions.
- Review container logs (`docker logs <container_id>`).
- Ensure all dependencies are present in the final image.
- Check resource limits.

### Permissions Issues Inside Container

- Verify file/directory permissions in the image.
- Ensure the `USER` has necessary permissions for operations.
- Check mounted volumes permissions.

### Network Connectivity Issues

- Verify exposed ports (`EXPOSE`) and published ports (`-p` in `docker run`).
- Check container network configuration.
- Review firewall rules.

## Conclusion

Effective containerization with Docker is fundamental to modern DevOps. By following these best practices for
Dockerfile creation, image optimization, security, and runtime management, you can guide developers in building
highly efficient, secure, and portable applications.

**Key Differentiators in This Skill:**

- Mandatory use of SHELL instruction with xtrace for debugging
- No usage of `&&` for better error handling
- Security-first approach with `apt-get upgrade -y`
- Strict version pinning with wildcards for reproducibility
- Advanced space optimization with dpkg/apt configuration

Remember to continuously evaluate and refine your container strategies as your application evolves,
and don't hesitate to use `askQuestions` tool when user requirements need clarification.
