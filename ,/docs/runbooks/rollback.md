# Rollback Runbook

## Objective

Rollback failed deployments safely.

---

# Rollback with ArgoCD

Open:

```text
ArgoCD Dashboard

Select application:

web-frontend

Choose:

History → Rollback
Rollback with Git

Revert commit:

git revert <commit>
git push

ArgoCD automatically syncs rollback state.

Validate Rollback

Commands:

kubectl get pods -n web
kubectl rollout status deployment web-frontend -n web
Monitoring Validation

Check:

Grafana dashboards
Prometheus alerts
Application availability