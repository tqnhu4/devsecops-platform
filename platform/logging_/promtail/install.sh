#!/bin/bash

helm install promtail grafana/promtail \
  -n logging \
  -f values.yaml