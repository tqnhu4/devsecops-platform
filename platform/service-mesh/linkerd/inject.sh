#!/bin/bash

kubectl get deploy web-frontend -n web -o yaml \
  | linkerd inject - \
  | kubectl apply -f -