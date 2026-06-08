#!/bin/bash

set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: ./generate-sbom.sh <image>"
  exit 1
fi

echo "Generating SBOM..."

syft $IMAGE \
  -o cyclonedx-json \
  > sbom.json

echo "SBOM generated: sbom.json"