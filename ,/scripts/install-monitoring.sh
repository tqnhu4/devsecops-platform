#!/bin/bash

set -e

echo "Installing Monitoring Stack..."

bash platform/monitoring/install.sh

echo "Installing Loki..."

bash platform/logging/loki/install.sh

echo "Installing Fluentbit..."

bash platform/logging/fluentbit/install.sh

echo "Observability stack installed successfully"