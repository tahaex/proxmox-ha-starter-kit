#!/usr/bin/env bash
set -euo pipefail

checks=(
  "Root login disabled over SSH"
  "Password authentication disabled"
  "PVE firewall enabled"
  "Fail2ban service active"
  "Automatic security updates enabled"
  "Backup jobs and restore test documented"
)

echo "== Security Audit Checklist =="
for item in "${checks[@]}"; do
  echo "[ ] $item"
done
