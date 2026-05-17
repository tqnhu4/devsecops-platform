# Supply Chain Security

## Overview

Supply chain security protects:

- Source code
- Build pipeline
- Container images
- Dependencies
- Deployment integrity

---

# Security Flow

```text
Developer Push
      ↓
Build Container
      ↓
Trivy Scan
      ↓
Generate SBOM
      ↓
Cosign Sign Image
      ↓
Push Registry
      ↓
Kyverno Verify Signature
      ↓
Deploy Secure Workload

Trivy

Used for:

Vulnerability scanning
Kubernetes config scanning
Filesystem scanning

Scans:

Docker images
IaC
Kubernetes manifests
Cosign

Used for:

Container image signing
Verification
Attestations

Benefits:

Prevent unsigned images
Prevent image tampering
Verify trusted builds
SBOM

Software Bill of Materials includes:

Dependencies
Libraries
Versions
Licenses

Generated using:

Syft
Kyverno Verification

Kyverno validates:

Signed images
Security contexts
Pod policies

Example:

verifyImages:
  - imageReferences:
      - ghcr.io/company/*
SLSA

Supply-chain Levels for Software Artifacts improves:

Provenance
Integrity
Build transparency