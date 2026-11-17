#!/usr/bin/env bash
# register-providers.sh — register the resource providers used across the lab.
# Idempotent: providers already registered are skipped.
# Usage:  bash register-providers.sh            # register
#         bash register-providers.sh --status   # show state
set -euo pipefail

PROVIDERS=(
  Microsoft.Management            # Phase 1 – management groups
  Microsoft.Network               # Phase 2 – VNets, NSGs, DNS, App Gateway
  Microsoft.Compute               # Phase 3 – VMs, scale sets
  Microsoft.Web                   # Phase 3 – App Service, Functions
  Microsoft.ContainerInstance     # Phase 3 – ACI
  Microsoft.Storage               # Phase 4 – storage accounts
  Microsoft.StorageSync           # Phase 4 – Azure File Sync
  Microsoft.Sql                   # Phase 4 – Azure SQL
  Microsoft.DocumentDB            # Phase 4 – Cosmos DB
  Microsoft.KeyVault              # Phase 5 – Key Vault
  Microsoft.Security              # Phase 5 – Defender for Cloud
  Microsoft.Insights              # Phase 6 – Monitor, alerts, App Insights
  Microsoft.OperationalInsights   # Phase 6 – Log Analytics
  Microsoft.AlertsManagement      # Phase 6 – alert processing
  Microsoft.PolicyInsights        # Phase 6 – Azure Policy compliance
  Microsoft.Advisor               # Phase 6 – Advisor
  Microsoft.ResourceHealth        # Phase 6 – Service / Resource Health
)

state() {
  # tr strips the \r that az adds on Windows (Git Bash)
  az provider show --namespace "$1" --query registrationState -o tsv | tr -d '\r'
}

if [[ "${1:-}" == "--status" ]]; then
  for ns in "${PROVIDERS[@]}"; do
    printf '%-32s %s\n' "$ns" "$(state "$ns")"
  done
  exit 0
fi

for ns in "${PROVIDERS[@]}"; do
  if [[ "$(state "$ns")" == "Registered" ]]; then
    echo "ok        $ns"
  else
    az provider register --namespace "$ns" --output none
    echo "register  $ns"
  fi
done

echo
echo "Registration runs in the background (1–5 min). Check with: bash $0 --status"