#!/usr/bin/env bash
set -euo pipefail

OUTPUT_FILE="${1:-ha_groups_generated.cfg}"

cat > "$OUTPUT_FILE" <<'CFG'
group: critical
  nodes: pve1:3,pve2:2,pve3:1
  comment: Critical services migrate first

group: standard
  nodes: pve1:2,pve2:2,pve3:2
  comment: Balanced workloads

group: low-priority
  nodes: pve3:3,pve2:2,pve1:1
  comment: Non-critical workloads migrate last
CFG

echo "HA group config generated at $OUTPUT_FILE"
