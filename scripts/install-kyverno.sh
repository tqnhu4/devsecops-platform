#!/bin/bash

set -e

echo "Installing Kyverno..."

kubectl create namespace kyverno --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f \
https://github.com/kyverno/kyverno/releases/latest/download/install.yaml

echo ""
echo "Waiting for Kyverno..."

kubectl rollout status deployment kyverno-admission-controller \
  -n kyverno

echo ""
echo "Kyverno installed successfully."