# GitOps Flow

## What is GitOps?

GitOps is an operational model where:

- Git is the source of truth
- Kubernetes state is declarative
- Changes are automated
- Drift is automatically corrected

---

# GitOps Workflow

```text
Developer Commit
       ↓
GitHub Repository
       ↓
ArgoCD Detect Changes
       ↓
Sync Kubernetes Manifests
       ↓
Deploy Application
       ↓
Self-Healing + Drift Detection


Repository Structure
applications/
    Source code

gitops/
    Kubernetes manifests

platform/
    Platform components

security/
    Security tooling
Benefits
Declarative Infrastructure

All infrastructure exists as code.

Drift Detection

ArgoCD automatically detects configuration drift.

Self Healing

If resources change manually:

kubectl edit deployment

ArgoCD automatically restores desired state.

Auditing

Every deployment is traceable through Git history.

ArgoCD Features
Automated sync
Prune old resources
Self-healing
Rollback support
Multi-cluster support