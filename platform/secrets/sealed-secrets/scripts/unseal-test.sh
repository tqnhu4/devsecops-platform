#!/bin/bash

kubectl apply -f $1

kubectl get secret -A