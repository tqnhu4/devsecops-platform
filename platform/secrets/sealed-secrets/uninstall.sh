#!/bin/bash

helm uninstall sealed-secrets \
-n sealed-secrets

kubectl delete namespace sealed-secrets