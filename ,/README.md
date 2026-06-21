# Enterprise DevSecOps GitOps Platform

A production-style local DevSecOps + GitOps platform using:

- Kubernetes
- ArgoCD
- Kyverno
- GitHub Actions
- Trivy
- Cosign
- Falco
- Prometheus
- Grafana

---

# Features

- GitOps workflow
- Secure CI/CD
- Container image signing
- Policy-as-Code
- Runtime security
- Monitoring & observability
- Supply chain security
- Multi-environment structure

---

# Quick Start

## Create Cluster

```bash
make cluster
```

Bootstrap Platform
make bootstrap
Deploy Applications
make deploy
Architecture
Developer
    ↓
GitHub Actions
    ↓
Trivy Scan
    ↓
Cosign Sign
    ↓
GHCR
    ↓
ArgoCD
    ↓
Kyverno
    ↓
Kubernetes
Components
Layer	Technology
CI/CD	GitHub Actions
GitOps	ArgoCD
Kubernetes	k3d
Security	Kyverno + Cosign
Runtime	Falco
Monitoring	Prometheus + Grafana
Learning Goals
DevSecOps
GitOps
Platform Engineering
Kubernetes Security
CI/CD Security
Supply Chain Security