#!/usr/bin/env bash
set -euo pipefail

PRUNE_OK="${1:-1}"
VERIFY_OK="${2:-1}"
OFFSITE_OK="${3:-1}"

for v in "$PRUNE_OK" "$VERIFY_OK" "$OFFSITE_OK"; do
  if ! [[ "$v" =~ ^[0-9]+$ ]]; then
    echo "Inputs must be numeric values."
    exit 1
  fi
done

# Weighting rationale: verification is highest impact for recoverability confidence.
score=$(( PRUNE_OK * 30 + VERIFY_OK * 40 + OFFSITE_OK * 30 ))

echo "== Backup Health Report =="
echo "Prune Status: $PRUNE_OK"
echo "Verify Status: $VERIFY_OK"
echo "Offsite Sync Status: $OFFSITE_OK"
echo "Health Score: ${score}/100"

if [ "$score" -ge 80 ]; then
  echo "Status: HEALTHY"
else
  echo "Status: ATTENTION REQUIRED"
fi
