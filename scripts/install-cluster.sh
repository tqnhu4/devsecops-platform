#!/bin/bash

set -e

echo "Creating k3d cluster..."

k3d cluster create devsecops \
  --agents 2 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0"

echo ""
echo "Waiting for cluster nodes..."

kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo ""
echo "Pulling Kyverno images..."

docker pull reg.kyverno.io/kyverno/kyverno:v1.18.1
docker pull reg.kyverno.io/kyverno/kyvernopre:v1.18.1
docker pull reg.kyverno.io/kyverno/background-controller:v1.18.1
docker pull reg.kyverno.io/kyverno/cleanup-controller:v1.18.1
docker pull reg.kyverno.io/kyverno/reports-controller:v1.18.1

echo ""
echo "Importing images into k3d..."

k3d image import \
  reg.kyverno.io/kyverno/kyverno:v1.18.1 \
  reg.kyverno.io/kyverno/kyvernopre:v1.18.1 \
  reg.kyverno.io/kyverno/background-controller:v1.18.1 \
  reg.kyverno.io/kyverno/cleanup-controller:v1.18.1 \
  reg.kyverno.io/kyverno/reports-controller:v1.18.1 \
  -c devsecops

echo ""
echo "Verifying images inside nodes..."

docker exec -it k3d-devsecops-server-0 crictl images | grep kyverno || true
docker exec -it k3d-devsecops-agent-0 crictl images | grep kyverno || true
docker exec -it k3d-devsecops-agent-1 crictl images | grep kyverno || true

echo ""
echo "Cluster created successfully."

kubectl get nodes