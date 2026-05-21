#!/bin/bash

set -e

echo "======================================"
echo " Enterprise DevSecOps Bootstrap"
echo "======================================"

echo ""
echo "[1/6] Creating Kubernetes Cluster..."
bash scripts/install-cluster.sh


#--
echo "Installing namespaces..."
kubectl apply -k platform/namespaces


echo ""
echo "[1.1/6] Installing Monitoring Stack..."
bash scripts/install-monitoring.sh


echo ""
echo "[2/6] Installing ingress-nginx..."
bash scripts/install-ingress.sh

#--
echo "Installing ingress-nginx..."
kubectl apply -k platform/ingress-nginx

echo ""
echo "[3/6] Installing ArgoCD..."
bash scripts/install-argocd.sh

#--
echo "Installing ArgoCD..."
kubectl apply -k platform/argocd

echo ""
echo "[4/6] Installing Kyverno..."
bash scripts/install-kyverno.sh

#--
echo "Installing Kyverno..."
kubectl apply -k platform/kyverno


#--
kubectl apply -k platform/monitoring

echo ""
echo "[6/6] Installing Falco Runtime Security..."
bash scripts/install-falco.sh

#--
echo "Bootstrapping GitOps..."
kubectl apply -f platform/bootstrap/platform-root.yaml

#--
echo "Deploy web-frontend"
kubectl apply -f gitops/argocd/web-frontend-app.yaml

echo ""
echo "======================================"
echo " Platform Bootstrap Completed"
echo "======================================"

echo ""
echo "Useful URLs:"
echo "- ArgoCD   : https://argocd.local"
echo "- Grafana  : http://grafana.local"
echo "- Frontend : http://devsecops.local"