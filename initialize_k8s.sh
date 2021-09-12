#!/bin/bash

set -e

kubectl apply -f apps/hello-world
kubectl apply -f apps/canary/index_v1_html.yml
kubectl apply -f apps/canary/canary-v1.yml
kubectl apply -f apps/blue-green