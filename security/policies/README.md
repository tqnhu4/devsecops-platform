# Kubernetes Security Policies

This directory contains:

- Kyverno policies
- Pod security enforcement
- Image signature verification
- Runtime restrictions

## Included Policies

- Disallow latest tag
- Require resource limits
- Require probes
- Require security context
- Require readonly filesystem
- Restrict privileged containers
- Restrict Linux capabilities
- Verify Cosign signatures

## Policy Engine

- Kyverno

## Security Goals

- Secure by default
- Policy-as-Code
- Zero trust workloads
- Kubernetes hardening