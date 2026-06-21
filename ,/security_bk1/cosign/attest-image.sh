#!/bin/bash

set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: ./attest-image.sh <image>"
  exit 1
fi

echo "Attesting image..."

cosign attest \
  --key cosign.key \
  --predicate ../attestations/provenance.json \
  --type slsaprovenance \
  $IMAGE

echo "Attestation completed."