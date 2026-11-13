#!/usr/bin/env bash
set -euo pipefail

echo "=== EKS Nodes ==="
kubectl get nodes -o wide

echo ""
echo "=== Application Pods (app-prod) ==="
kubectl -n app-prod get pods,svc

echo ""
echo "=== Monitoring Pods (monitoring) ==="
kubectl -n monitoring get pods,svc

LB_HOST="$(kubectl -n app-prod get svc order-status-api -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)"
if [[ -n "${LB_HOST}" ]]; then
  echo ""
  echo "=== Checking /health on http://${LB_HOST}/health ==="
  curl -fsS "http://${LB_HOST}/health" || echo "LoadBalancer is still provisioning."
fi
