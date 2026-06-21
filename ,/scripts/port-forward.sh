#!/bin/bash

set -e

echo "======================================"
echo " Port Forward Services"
echo "======================================"

echo ""
echo "1. ArgoCD     → https://localhost:8081"
echo "2. Grafana    → http://localhost:3000"
echo "3. Prometheus → http://localhost:9090"
echo ""

kubectl port-forward svc/argocd-server -n argocd 8081:443 &

kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80 &
->
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80 &


kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 &
->
kubectl port-forward svc/monitoring-prometheus -n monitoring 9090:9090 &


Post "http://monitoring-kube-prometheus-prometheus:9090/api/v1/query_range": dial tcp: lookup monitoring-kube-prometheus-prometheus on 10.43.0.10:53: no such host, Post "http://monitoring-kube-prometheus-prometheus:9090/api/v1/query_range": dial tcp: lookup monitoring-kube-prometheus-prometheus on 10.43.0.10:53: no such host


