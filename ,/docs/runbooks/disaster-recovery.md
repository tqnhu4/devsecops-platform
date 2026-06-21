# Disaster Recovery Runbook

## Objective

Recover platform after major outage.

---

# Recovery Scenarios

- Cluster failure
- Node failure
- Registry outage
- Git repository corruption

---

# Restore Kubernetes Cluster

Recreate cluster:

```bash
bash scripts/install-cluster.sh

Restore Platform Components
bash scripts/bootstrap.sh
Restore GitOps State

Apply ArgoCD apps:

kubectl apply -f gitops/argocd/

ArgoCD restores workloads automatically.

Restore Secrets

Restore:

Sealed Secrets
External Secrets
Vault integrations
Verify Recovery

Check:

kubectl get pods -A
kubectl get ingress -A
kubectl get svc -A
Recovery Goals
RTO

Recovery Time Objective:

< 30 minutes
RPO

Recovery Point Objective:

Git repository state