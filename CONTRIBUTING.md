# Contributing Guide

Thank you for contributing.

---

# Development Workflow

1. Fork repository
2. Create feature branch
3. Commit changes
4. Open pull request

---

# Commit Convention

Example:

```text
feat: add falco runtime policy
fix: resolve ingress issue
docs: update architecture

Validation

Before submitting:

make health

Run:

bash security/trivy/trivy-fs-scan.sh
Pull Request Rules
Keep PRs small
Update documentation
Validate manifests
Avoid secrets in commits