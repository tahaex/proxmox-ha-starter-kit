#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 --master <ip-or-hostname> [--fingerprint <sha256>] [--dry-run]"
}

MASTER=""
FINGERPRINT=""
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    --master) MASTER="$2"; shift 2 ;;
    --fingerprint) FINGERPRINT="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) usage; exit 1 ;;
  esac
done

if [ -z "$MASTER" ]; then
  usage
  exit 1
fi

if [ "$DRY_RUN" = true ]; then
  if [ -n "$FINGERPRINT" ]; then
    echo "[DRY-RUN] pvecm add '$MASTER' --fingerprint '$FINGERPRINT'"
  else
    echo "[DRY-RUN] pvecm add '$MASTER'"
  fi
else
  if [ -n "$FINGERPRINT" ]; then
    pvecm add "$MASTER" --fingerprint "$FINGERPRINT"
  else
    pvecm add "$MASTER"
  fi
fi

pvecm status
