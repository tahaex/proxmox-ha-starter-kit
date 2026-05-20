#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 --cluster-name <name> --bindnet <cidr> [--dry-run]"
}

CLUSTER_NAME=""
BINDNET=""
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    --cluster-name) CLUSTER_NAME="$2"; shift 2 ;;
    --bindnet) BINDNET="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) usage; exit 1 ;;
  esac
done

if [ -z "$CLUSTER_NAME" ] || [ -z "$BINDNET" ]; then
  usage
  exit 1
fi

run() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY-RUN] $*"
  else
    "$@"
  fi
}

echo "== Bootstrap Proxmox Cluster =="
run pvecm create "$CLUSTER_NAME" -bindnet0_addr "$BINDNET"
run pvecm status

echo "Cluster bootstrap completed."
