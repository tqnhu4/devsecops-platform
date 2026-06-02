#!/bin/bash

set -e

echo "Installing Sealed Secrets..."

kubectl create namespace sealed-secrets \
  --dry-run=client -o yaml | kubectl apply -f -

helm repo add sealed-secrets \
https://bitnami-labs.github.io/sealed-secrets

helm repo update

helm upgrade --install sealed-secrets \
sealed-secrets/sealed-secrets \
-n sealed-secrets \
-f base/helm-values.yaml

echo "Waiting controller..."

kubectl rollout status deploy/sealed-secrets-controller \
-n sealed-secrets

echo "Done"