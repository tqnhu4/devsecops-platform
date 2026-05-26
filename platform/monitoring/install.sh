#!/bin/bash

set -e

helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring \
-f platform/monitoring/values.yaml

kubectl apply -f platform/monitoring/grafana-ingress.yaml

kubectl apply -f platform/monitoring/prometheus-rules.yaml

kubectl apply -f platform/monitoring/datasources/

kubectl apply -f platform/monitoring/dashboards/

echo "Monitoring stack installed successfully"