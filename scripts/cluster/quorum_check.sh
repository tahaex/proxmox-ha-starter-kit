#!/usr/bin/env bash
set -euo pipefail

echo "== Quorum Health Check =="
status="$(pvecm status 2>/dev/null || true)"
if echo "$status" | grep -q "Quorate: Yes"; then
  echo "[OK] Cluster is quorate"
  exit 0
fi

echo "[CRITICAL] Cluster is not quorate"
echo "$status"
exit 2
