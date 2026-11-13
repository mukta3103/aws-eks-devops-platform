#!/usr/bin/env bash
set -euo pipefail

REQUIRED_TOOLS=("aws" "terraform" "ansible" "kubectl" "docker" "git")

echo "Checking local DevOps prerequisites..."
for tool in "${REQUIRED_TOOLS[@]}"; do
  if command -v "${tool}" >/dev/null 2>&1; then
    echo "[OK] ${tool} -> $(command -v "${tool}")"
  else
    echo "[MISSING] ${tool} is not installed or not in PATH."
    exit 1
  fi
done

echo "Verifying AWS caller identity..."
aws sts get-caller-identity --output table
echo "All prerequisites verified."
