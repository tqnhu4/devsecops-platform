#!/bin/bash

SECRET_FILE=$1
OUTPUT_FILE=$2

kubeseal \
--format yaml \
--cert certs/sealed-secrets.crt \
< $SECRET_FILE \
> $OUTPUT_FILE

echo "Generated:"
echo $OUTPUT_FILE