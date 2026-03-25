---
name: fc-optimize-helm
description: 'Comprehensive best practices for creating optimized, secure, and efficient Helm charts and managing Kubernetes deployments. Covers chart structure, templating, values management, and deployment best practices. Applies to **/charts/**,**/helm/**,**/k8s/**,**/kubernetes/**'
licence: MIT
---

# Orchestration (Kubernetes, Docker Swarm)

- **Principle:** Use an orchestrator for managing containerized applications at scale.
- **Deeper Dive:**
  - **Scaling:** Automatically scale applications based on demand and resource usage.
  - **Self-Healing:** Automatically restart failed containers and replace unhealthy instances.
  - **Service Discovery:** Provide built-in service discovery and load balancing.
  - **Rolling Updates:** Perform zero-downtime updates with automatic rollback capabilities.
- **Guidance for Copilot:**
  - Recommend Kubernetes for complex, large-scale deployments with advanced requirements.
  - Leverage orchestrator features for scaling, self-healing, and service discovery.
  - Use rolling update strategies for zero-downtime deployments.
  - Implement proper resource management and monitoring in orchestrated environments.
- **Example (Kubernetes Deployment):**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

## Validation & linting

- **Principle:** Validate and lint Dockerfiles and Helm charts to ensure best practices and catch errors early.
- **Deeper Dive:**
  - Use tools like helm lint for Helm charts
  - Integrate validation and linting into CI/CD pipelines for automated checks.
  - Continuously improve from errors found during builds and linting, indicate in the report what needs to be added to `fc-optimize-helm` skill next time.
