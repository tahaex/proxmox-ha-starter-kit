#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
COMPAT_FILE="scripts/validation/compatibility_matrix.yaml"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
  esac
done

echo "== Global Preflight Checker =="
if [ -f "$COMPAT_FILE" ]; then
  echo "[OK] Compatibility matrix present: $COMPAT_FILE"
else
  echo "[WARN] Missing compatibility matrix"
fi

if command -v pveversion >/dev/null 2>&1; then
  echo "[OK] pveversion available"
else
  echo "[WARN] pveversion not found"
fi

if [ "$DRY_RUN" = true ]; then
  echo "Dry-run enabled: no system modifications will be applied."
fi
