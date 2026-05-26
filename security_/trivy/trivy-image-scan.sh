#!/bin/bash

set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: ./trivy-image-scan.sh <image>"
  exit 1
fi

trivy image \
  --severity HIGH,CRITICAL \
  --ignorefile .trivyignore \
  $IMAGE