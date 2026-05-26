#!/bin/bash

set -e

echo "Generating Cosign key pair..."

cosign generate-key-pair

echo "Done."

echo "Files generated:"
echo "- cosign.key"
echo "- cosign.pub"