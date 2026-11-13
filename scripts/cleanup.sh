#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${SCRIPT_DIR}/../terraform"

echo "Deleting Kubernetes LoadBalancer services to release AWS ELBs/ENIs..."
kubectl delete -f "${SCRIPT_DIR}/../kubernetes/app/service.yaml" --ignore-not-found=true || true
kubectl delete -f "${SCRIPT_DIR}/../kubernetes/monitoring/grafana-deployment.yaml" --ignore-not-found=true || true

echo "Waiting 20 seconds for AWS load balancers to detach..."
sleep 20

cd "${TF_DIR}"
echo "Destroying Terraform-managed AWS infrastructure..."
terraform destroy -auto-approve

echo "Cleanup complete."
