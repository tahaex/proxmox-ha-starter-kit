#!/usr/bin/env bash
set -euo pipefail

NODES="${1:-3}"

echo "== Service Placement Advisor =="
if [ "$NODES" = "2" ]; then
  cat <<'ADVICE'
- Keep database and reverse proxy on distinct nodes.
- Put backup and dev workloads on secondary node.
- Use QDevice/witness if possible to improve quorum safety.
ADVICE
else
  cat <<'ADVICE'
- Place critical DB and ingress across node1/node2.
- Keep node3 for witness/light workloads and failover headroom.
- Assign low-priority workloads to node3 first.
ADVICE
fi
