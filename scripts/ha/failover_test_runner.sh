#!/usr/bin/env bash
set -euo pipefail

NODE_TO_SIMULATE="${1:-}"
if [ -z "$NODE_TO_SIMULATE" ]; then
  echo "Usage: $0 <node-name>"
  exit 1
fi

echo "== HA Failover Simulation Plan =="
echo "1) Record baseline: ha-manager status"
echo "2) Migrate non-critical workloads off $NODE_TO_SIMULATE"
echo "3) Simulate failure: systemctl stop pve-cluster (lab only)"
echo "4) Observe relocation timings and recovery status"
echo "5) Restore node services and confirm rebalancing"

echo
ha-manager status || true
