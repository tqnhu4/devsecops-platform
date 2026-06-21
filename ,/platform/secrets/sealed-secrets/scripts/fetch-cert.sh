#!/bin/bash

mkdir -p certs

kubeseal \
--fetch-cert \
--controller-name=sealed-secrets-controller \
--controller-namespace=sealed-secrets \
> certs/sealed-secrets.crt