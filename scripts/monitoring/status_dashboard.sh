#!/usr/bin/env bash
set -euo pipefail

echo "== Proxmox Quick Status Dashboard =="
echo "--- Cluster ---"
pvecm status || true

echo
echo "--- HA ---"
ha-manager status || true

echo
echo "--- Storage ---"
pvesm status || true

echo
echo "--- Last Backup Tasks ---"
journalctl -u proxmox-backup --since "24 hours ago" --no-pager | tail -n 40 || true
