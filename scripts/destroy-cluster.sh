#!/bin/bash

set -e

echo "Destroying k3d cluster..."

k3d cluster delete devsecops

echo ""
echo "Cluster removed successfully."