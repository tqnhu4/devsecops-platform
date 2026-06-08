#!/bin/bash

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install loki grafana/loki \
  -n logging \
  -f values.yaml