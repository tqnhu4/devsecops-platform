#!/bin/bash

set -e

echo "======================================"
echo " Enterprise DevSecOps Bootstrap"
echo "======================================"

echo ""
echo "[1/6] Creating Kubernetes Cluster..."
bash scripts/install-cluster.sh

echo ""
echo "[2/6] Creating Namespaces..."
kubectl apply -k platform/namespaces

echo ""
echo "[3/6] Installing ingress-nginx..."
bash scripts/install-ingress.sh

echo ""
echo "[4/6] Installing ArgoCD..."
bash scripts/install-argocd.sh

echo ""
echo "[5/6] Installing Kyverno..."
bash scripts/install-kyverno.sh

#echo ""
#echo "[6/6] Installing Monitoring..."
#bash scripts/install-monitoring.sh


echo ""
echo "Applying AppProject..."
kubectl apply -f platform/bootstrap/projects-root.yaml

echo ""
echo "Bootstrapping Platform Root App..."
kubectl apply -f platform/bootstrap/platform-root.yaml

echo "Waiting Platform..."
argocd app wait platform-root --health --sync

echo ""
echo "Bootstrapping Application Root App..."
kubectl apply -f platform/bootstrap/apps-root.yaml


echo ""
echo "======================================"
echo " Platform Bootstrap Completed"
echo "======================================"