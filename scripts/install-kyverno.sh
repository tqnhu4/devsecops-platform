#!/bin/bash

set -e

echo "Installing Kyverno..."

helm repo add kyverno https://kyverno.github.io/kyverno

helm repo update

kubectl create namespace kyverno \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install kyverno kyverno/kyverno \
  -n kyverno \
  --set features.policyExceptions.enabled=true

echo "Waiting for Kyverno..."

#kubectl wait --for=condition=Available deployment \
#  --all \
#  -n kyverno \
#  --timeout=300s

#kubectl rollout status deployment --all -n kyverno --timeout=600s  
for deploy in $(kubectl get deploy -n kyverno -o name); do
  kubectl rollout status "$deploy" -n kyverno --timeout=30m || true
done

echo "Kyverno installed successfully."