#!/bin/bash
set -e

helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

helm upgrade --install sealed-secrets \
    sealed-secrets/sealed-secrets \
    --namespace kube-system \
    --create-namespace

echo "Waiting for Sealed Secrets CRD..."

kubectl wait \
    --for=condition=Established \
    crd/sealedsecrets.bitnami.com \
    --timeout=120s

kubectl rollout status \
    deployment/sealed-secrets \
    -n kube-system \
    --timeout=180s