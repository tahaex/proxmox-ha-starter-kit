#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-/etc/network/interfaces}"

echo "== Network Validation =="
if grep -q "bridge-vlan-aware yes" "$FILE"; then
  echo "[OK] VLAN-aware bridge enabled"
else
  echo "[WARN] VLAN-aware bridge setting not found"
fi

if grep -q "bond-mode 802.3ad" "$FILE"; then
  echo "[OK] LACP bond mode detected"
else
  echo "[WARN] LACP bond mode not detected"
fi
