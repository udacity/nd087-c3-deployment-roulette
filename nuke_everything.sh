#!/bin/bash

set -e

terraform state rm kubernetes_namespace.udacity && terraform state rm kubernetes_service.blue
eksctl delete iamserviceaccount --name cluster-autoscaler --namespace kube-system --cluster udacity-cluster --region us-east-2
kubectl delete all --all -n udacity
terraform destroy