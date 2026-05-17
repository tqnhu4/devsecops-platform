# Local Development Setup

## Requirements

Install:

- Docker
- kubectl
- k3d
- Helm
- Git
- Cosign
- Trivy

---

# Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/enterprise-devsecops-platform.git

Create Cluster
bash scripts/install-cluster.sh
Install Platform
bash scripts/bootstrap.sh
Verify Cluster
kubectl get nodes
Access Services
ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8081:443

Open:

https://localhost:8081
Grafana
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80

Open:

http://localhost:3000
Deploy Application
kubectl apply -f gitops/argocd/web-frontend-app.yaml
Verify Deployment
kubectl get pods -n web
Local DNS

Edit:

/etc/hosts

Add:

127.0.0.1 devsecops.local
127.0.0.1 argocd.local
127.0.0.1 grafana.local
Useful Commands
Health Check
bash scripts/healthcheck.sh
Destroy Cluster
bash scripts/destroy-cluster.sh