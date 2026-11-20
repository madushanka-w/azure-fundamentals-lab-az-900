#!/usr/bin/env bash
# check-tags.sh — report resource groups (or resources) missing the lab's required tags.
# Standard: docs/naming-and-tagging.md
# Usage:
#   bash check-tags.sh               # check resource groups
#   bash check-tags.sh --resources   # check individual resources
# Exit code: 0 = all compliant, 1 = at least one problem
set -euo pipefail
source "$(git rev-parse --show-toplevel)/scripts/lab-standards.sh"

if [[ "${1:-}" == "--resources" ]]; then
  list_cmd=(az resource list)
  label="resources"
  show="[resourceGroup, name]"
  # Skip resources inside resource groups that Azure creates for itself
  skip="resourceGroup != 'NetworkWatcherRG' && !starts_with(resourceGroup, 'DefaultResourceGroup-')"
else
  list_cmd=(az group list)
  label="resource groups"
  show="name"
  skip="name != 'NetworkWatcherRG' && !starts_with(name, 'DefaultResourceGroup-')"
fi

# JMESPath list of allowed managedBy values, e.g. ['portal','cli','bicep','terraform']
allowed=$(printf "'%s'," "${LAB_MANAGED_BY[@]}")
allowed="[${allowed%,}]"

problems=0
for key in "${LAB_REQUIRED_TAGS[@]}"; do
  # Each rule is TRUE for a broken item. "|| ''" turns a missing tag into an empty string.
  case "$key" in
    project)   rule="tags.project != '${LAB_PROJECT}'" ;;
    env)       rule="tags.env != '${LAB_ENV}'" ;;
    owner)     rule="tags.owner != '${LAB_OWNER}'" ;;
    phase)     rule="!starts_with(tags.phase || '', 'phase-')" ;;
    managedBy) rule="!contains(${allowed}, tags.managedBy || '')" ;;
  esac

  bad=$("${list_cmd[@]}" --query "[?(${rule}) && ${skip}].${show}" -o tsv | tr -d '\r')
  if [[ -n "$bad" ]]; then
    echo "[FAIL] '${key}' missing or wrong on:"
    sed 's/^/         /' <<< "$bad"
    problems=1
  fi
done

if (( problems == 0 )); then
  echo "[OK] All ${label} have the required tags."
fi
exit "$problems"