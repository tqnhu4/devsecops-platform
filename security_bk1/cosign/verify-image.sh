#!/bin/bash

set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: ./verify-image.sh <image>"
  exit 1
fi

echo "Verifying image signature..."

cosign verify \
  --key cosign.pub \
  $IMAGE

echo "Verification successful."