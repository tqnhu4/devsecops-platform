# Runtime Security

## Overview

Runtime security protects workloads during execution.

This project uses:

- Falco
- Kubernetes policies
- Network policies
- Pod security controls

---

# Runtime Threats

Examples:

- Reverse shells
- Crypto miners
- Privileged containers
- Container escape attempts
- Suspicious binaries

---

# Falco

Falco monitors:

- System calls
- Container behavior
- Kubernetes audit logs

Example detection:

```text
Shell executed inside container

Network Policies

Restrict:

Pod communication
Namespace communication
Egress traffic

Benefits:

Zero trust networking
Reduce lateral movement
Pod Security

Security controls include:

Non-root containers
Readonly filesystem
Drop Linux capabilities
Disable privilege escalation
Runtime Monitoring

Monitoring stack:

Prometheus
Grafana
Loki

Tracks:

Pod restarts
CPU usage
Security events