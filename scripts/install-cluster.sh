#!/bin/bash

set -e

echo "Creating k3d cluster..."

k3d cluster create devsecops \
  --agents 2 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer"

echo ""
echo "Cluster created successfully."

echo ""
kubectl get nodes