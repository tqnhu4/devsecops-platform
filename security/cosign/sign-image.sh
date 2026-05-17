#!/bin/bash

set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: ./sign-image.sh <image>"
  exit 1
fi

echo "Signing image: $IMAGE"

cosign sign \
  --key cosign.key \
  $IMAGE

echo "Image signed successfully."