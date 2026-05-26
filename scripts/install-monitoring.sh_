#!/bin/bash

set -e

echo "Installing Monitoring Stack..."

helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create namespace monitoring \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install monitoring \
  prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f platform/monitoring/values.yaml

echo ""
echo "Monitoring stack installed."

echo ""
echo "Grafana access:"
echo "kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80"