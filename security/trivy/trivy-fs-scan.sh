#!/bin/bash

set -e

trivy fs \
  --severity HIGH,CRITICAL \
  --ignorefile .trivyignore \
  .