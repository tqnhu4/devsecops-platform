#!/bin/bash

set -e

echo "Installing ArgoCD..."

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo ""
echo "Waiting for ArgoCD server..."

kubectl rollout status deployment argocd-server -n argocd

echo ""
echo "ArgoCD installed."

echo ""
echo "Get admin password using:"
echo ""
echo "kubectl -n argocd get secret argocd-initial-admin-secret \\"
echo "  -o jsonpath=\"{.data.password}\" | base64 -d"