#!/bin/bash

VERSION=0.30.0

wget \
https://github.com/bitnami-labs/sealed-secrets/releases/download/v${VERSION}/kubeseal-${VERSION}-linux-amd64.tar.gz

tar -xvzf kubeseal-${VERSION}-linux-amd64.tar.gz

sudo install kubeseal /usr/local/bin/kubeseal

kubeseal --version