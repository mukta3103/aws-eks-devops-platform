#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${SCRIPT_DIR}/../terraform"

cd "${TF_DIR}"

if [[ ! -f "terraform.tfvars" ]]; then
  echo "Error: terraform/terraform.tfvars not found. Copy terraform.tfvars.example first."
  exit 1
fi

echo "Initializing Terraform..."
terraform init

echo "Validating configuration..."
terraform validate

echo "Planning infrastructure changes..."
terraform plan -out=tfplan

echo "Applying infrastructure..."
terraform apply tfplan
rm -f tfplan

CLUSTER_NAME="$(terraform output -raw eks_cluster_name)"
AWS_REGION="$(grep -E '^aws_region' terraform.tfvars | awk -F'=' '{print $2}' | tr -d ' "' || echo 'ap-south-1')"

echo "Updating kubeconfig for cluster ${CLUSTER_NAME}..."
aws eks update-kubeconfig --region "${AWS_REGION}" --name "${CLUSTER_NAME}"

echo "EKS cluster is ready. Run ./scripts/health-check.sh after deploying workloads."
