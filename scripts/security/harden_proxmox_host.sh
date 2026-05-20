#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

run() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] $*"
  else
    "$@"
  fi
}

echo "== Proxmox Host Hardening =="
run apt-get update
run apt-get install -y unattended-upgrades fail2ban
run systemctl enable --now fail2ban
if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] pve-firewall status >/dev/null 2>&1 || true"
else
  pve-firewall status >/dev/null 2>&1 || true
fi

echo "Apply SSH hardening manually in /etc/ssh/sshd_config using docs/security/key_management.md guidance."
