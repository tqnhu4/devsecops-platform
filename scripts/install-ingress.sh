#!/bin/bash

set -e

echo "Installing ingress-nginx..."

kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

echo ""
echo "Waiting for ingress-nginx controller..."

kubectl rollout status deployment ingress-nginx-controller \
  -n ingress-nginx

echo ""
echo "Ingress installed successfully."