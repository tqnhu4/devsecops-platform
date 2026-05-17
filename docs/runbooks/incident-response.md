# Incident Response Runbook

## Objective

Respond quickly to security incidents affecting:

- Kubernetes
- Containers
- CI/CD
- Runtime workloads

---

# Step 1 — Detect Incident

Sources:

- Falco alerts
- Prometheus alerts
- Grafana dashboards
- Kubernetes events

---

# Step 2 — Identify Affected Resources

Commands:

```bash
kubectl get pods -A
kubectl describe pod <pod>
kubectl logs <pod>

Step 3 — Contain Incident

Actions:

Scale deployment to zero
Block ingress traffic
Remove compromised pod

Example:

kubectl scale deployment web-frontend --replicas=0 -n web
Step 4 — Investigate

Check:

Container image
Runtime logs
Kubernetes events
Git history
Step 5 — Recover

Actions:

Redeploy trusted image
Restore GitOps state
Validate monitoring
Step 6 — Postmortem

Document:

Timeline
Root cause
Impact
Preventive actions