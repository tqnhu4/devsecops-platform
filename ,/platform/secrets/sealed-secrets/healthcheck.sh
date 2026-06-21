#!/bin/bash

kubectl get pods -n sealed-secrets

kubectl get svc -n sealed-secrets

kubectl get sealedsecrets.bitnami.com -A