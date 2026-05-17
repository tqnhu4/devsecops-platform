#!/bin/bash

set -e

echo "======================================"
echo " Port Forward Services"
echo "======================================"

echo ""
echo "1. ArgoCD     → https://localhost:8081"
echo "2. Grafana    → http://localhost:3000"
echo "3. Prometheus → http://localhost:9090"
echo ""

kubectl port-forward svc/argocd-server \
  -n argocd 8081:443 &

kubectl port-forward svc/monitoring-grafana \
  -n monitoring 3000:80 &

kubectl port-forward svc/monitoring-kube-prometheus-prometheus \
  -n monitoring 9090:9090 &