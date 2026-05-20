#!/usr/bin/env bash
set -euo pipefail

print_result() {
  local status="$1" message="$2"
  if [ "$status" = "OK" ]; then
    echo "[OK] $message"
  else
    echo "[WARN] $message"
  fi
}

echo "== Proxmox Cluster Preflight =="

if command -v pveversion >/dev/null 2>&1; then
  print_result OK "Proxmox VE detected: $(pveversion | head -n1)"
else
  print_result WARN "pveversion command missing (run on Proxmox host)"
fi

if command -v pvecm >/dev/null 2>&1; then
  print_result OK "pvecm available"
else
  print_result WARN "pvecm missing"
fi

for cmd in corosync systemctl; do
  if command -v "$cmd" >/dev/null 2>&1; then
    print_result OK "$cmd available"
  else
    print_result WARN "$cmd missing"
  fi
done

free_gb=$(df --output=avail -BG / | tail -n1 | awk '{print $1}' | tr -d 'G')
if [ "${free_gb:-0}" -ge 20 ]; then
  print_result OK "Disk free space is ${free_gb}G"
else
  print_result WARN "Low disk space: ${free_gb:-0}G (<20G recommended)"
fi

echo "Preflight completed."
