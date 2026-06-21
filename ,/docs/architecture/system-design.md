# Enterprise DevSecOps GitOps Platform

## Overview

This platform demonstrates a production-style:

- DevSecOps Platform
- GitOps Workflow
- Kubernetes Platform Engineering Architecture
- Supply Chain Security Pipeline

The project runs fully local using:

- Docker
- k3d
- Kubernetes
- GitHub Actions
- ArgoCD
- Kyverno
- Cosign
- Trivy
- Prometheus
- Grafana

---

# High-Level Architecture

```text
Developer
    ↓
GitHub Push
    ↓
GitHub Actions CI/CD
    ↓
Trivy Security Scan
    ↓
Cosign Image Signing
    ↓
GHCR Registry
    ↓
ArgoCD GitOps Sync
    ↓
Kyverno Policy Validation
    ↓
Kubernetes Deployment
    ↓
Monitoring + Runtime Security


Core Components
CI/CD Layer

Responsible for:

Build automation
Security scanning
Image signing
SBOM generation
Artifact publishing

Tools:

GitHub Actions
Trivy
Cosign
Syft
GitOps Layer

Responsible for:

Desired state management
Automated synchronization
Drift detection
Self-healing

Tools:

ArgoCD
Kustomize
Kubernetes Layer

Responsible for:

Container orchestration
Scaling
Service discovery
Networking

Tools:

k3d
Kubernetes
ingress-nginx
Security Layer

Responsible for:

Policy enforcement
Signature verification
Runtime detection
Pod hardening

Tools:

Kyverno
Falco
Cosign
Observability Layer

Responsible for:

Metrics
Logging
Alerting
Dashboards

Tools:

Prometheus
Grafana
Loki
Promtail