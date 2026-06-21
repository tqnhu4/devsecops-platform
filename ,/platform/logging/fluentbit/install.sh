#!/bin/bash

set -e

kubectl create namespace logging --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f platform/logging/fluentbit/configmap.yaml

kubectl apply -f platform/logging/fluentbit/daemonset.yaml

echo "Fluentbit installed successfully"