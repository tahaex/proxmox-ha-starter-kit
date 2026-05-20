# Troubleshooting Playbooks

## Symptom: HA resources not moving
1. Check `ha-manager status`.
2. Validate quorum with `pvecm status`.
3. Confirm target node has available CPU/RAM/storage.

## Symptom: Backups failing
1. Review PBS service logs.
2. Validate datastore free space.
3. Run manual verification and test restore.

## Symptom: Cluster instability
1. Validate corosync link quality.
2. Check time sync/NTP status.
3. Inspect recent network changes on bonds/bridges.
