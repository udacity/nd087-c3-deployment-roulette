#!/bin/bash

set -e

cd starter/infra
echo "Remove Kubernetes state objects"
terraform state rm kubernetes_namespace.udacity && terraform state rm kubernetes_service.blue
echo "Delete Cluster Autoscaler Cloudformation Stack"
eksctl delete iamserviceaccount --name cluster-autoscaler --namespace kube-system --cluster udacity-cluster --region us-east-2
echo "Delete all kubernetes resources"
kubectl delete all --all -n udacity
echo "Delete all terraform managed resources"
terraform destroy