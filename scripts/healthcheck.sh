#!/bin/bash

echo "======================================"
echo " Platform Health Check"
echo "======================================"

echo ""
echo "Kubernetes Nodes"
kubectl get nodes

echo ""
echo "Namespaces"
kubectl get ns

echo ""
echo "Ingress Controller"
kubectl get pods -n ingress-nginx

echo ""
echo "ArgoCD"
kubectl get pods -n argocd

echo ""
echo "Kyverno"
kubectl get pods -n kyverno

echo ""
echo "Monitoring"
kubectl get pods -n monitoring

echo ""
echo "Falco"
kubectl get pods -n falco

echo ""
echo "Web Application"
kubectl get pods -n web

echo ""
echo "Ingress"
kubectl get ingress -A

echo ""
echo "Services"
kubectl get svc -A

echo ""
echo "======================================"
echo " Health Check Completed"
echo "======================================"