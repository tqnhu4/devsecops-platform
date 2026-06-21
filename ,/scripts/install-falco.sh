#!/bin/bash

set -e

echo "Installing Falco..."

helm repo add falcosecurity \
https://falcosecurity.github.io/charts

helm repo update

kubectl create namespace falco \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install falco \
  falcosecurity/falco \
  -n falco \
  -f platform/runtime-security/falco/values.yaml

echo ""
echo "Falco installed successfully."