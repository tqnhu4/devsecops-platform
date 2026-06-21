#!/bin/bash

set -e

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install loki \
grafana/loki-stack \
-n logging \
-f platform/logging/loki/values.yaml

echo "Loki installed successfully"