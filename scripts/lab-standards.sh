#!/usr/bin/env bash
# lab-standards.sh — shared naming + tagging values for every lab script.
# Standard: docs/naming-and-tagging.md
# Source it (don't run it) from any script or shell inside the repo:
#   source "$(git rev-parse --show-toplevel)/scripts/lab-standards.sh"

LAB_PROJECT="az900-lab"
LAB_ENV="lab"
LAB_OWNER="madushanka"
LAB_LOCATION="southeastasia"
LAB_SUFFIX="973f"   # 4 hex chars for globally unique names; generate once: openssl rand -hex 2
LAB_REQUIRED_TAGS=(project phase env owner managedBy)
LAB_MANAGED_BY=(portal cli bicep terraform)

# lab_tags <phase-N> [managedBy]  -> prints the required tags as key=value, one per line.
# Usage in a script (stops if the arguments are invalid):
#   tags=$(lab_tags phase-1 cli) || exit 1
#   mapfile -t TAGS <<< "$tags"
#   az group create -n rg-network -l "$LAB_LOCATION" --tags "${TAGS[@]}"
lab_tags() {
  local phase="${1:-}"
  local managed_by="${2:-cli}"

  if [[ ! "$phase" =~ ^phase-[0-7]$ ]]; then
    echo "lab_tags: phase must be phase-0 … phase-7 (got '${phase}')" >&2
    return 1
  fi
  if [[ " ${LAB_MANAGED_BY[*]} " != *" ${managed_by} "* ]]; then
    echo "lab_tags: managedBy must be one of: ${LAB_MANAGED_BY[*]} (got '${managed_by}')" >&2
    return 1
  fi

  printf '%s\n' \
    "project=${LAB_PROJECT}" \
    "phase=${phase}" \
    "env=${LAB_ENV}" \
    "owner=${LAB_OWNER}" \
    "managedBy=${managed_by}"
}