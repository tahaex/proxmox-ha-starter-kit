# 🐳 Proxmox High-Availability Starter Kit
## Production-Grade Infrastructure Automation

<p align="center">
  <strong>Sovereign Infrastructure: Own Your Data, Control Your Costs</strong><br>
  <em>Battle-tested configurations from the Netics Engineering Team</em>
</p>

---

## Overview

This repository is now an end-to-end starter toolkit for Proxmox operators covering:
- Cluster bootstrap and validation
- HA operations and failover simulation
- Backup + DR templates and health scoring
- Security hardening baselines
- Monitoring and alerting references
- Network architecture templates
- Docker/LXC modular bootstrap profiles

---

## Quick Start

```bash
git clone https://github.com/tahaex/proxmox-ha-starter-kit.git
cd proxmox-ha-starter-kit
find scripts -type f -name "*.sh" -exec chmod +x {} \;
chmod +x install_docker_optimized.sh
```

---

## Key Modules

### 1) Core Cluster Bootstrap
- `scripts/cluster/preflight.sh`
- `scripts/cluster/bootstrap_cluster.sh`
- `scripts/cluster/join_cluster.sh`
- `scripts/cluster/quorum_check.sh`
- Storage profiles: `profiles/storage/ceph_profile.yaml`, `profiles/storage/zfs_profile.yaml`
- Cloud-init templates: `templates/cloud-init/*`

### 2) HA Operations Toolkit
- `scripts/ha/generate_ha_groups.sh`
- `scripts/ha/failover_test_runner.sh`
- `scripts/ha/placement_advisor.sh`

### 3) Backup & Disaster Recovery
- `backup_strategy.yaml`
- `templates/backup/offsite_sync_job.yaml`
- `templates/backup/rpo_rto_presets.yaml`
- `scripts/backup/restore_test.sh`
- `scripts/backup/backup_health_report.sh`

### 4) Security Hardening Pack
- `scripts/security/harden_proxmox_host.sh`
- `scripts/security/audit_checklist.sh`
- `templates/security/lxc_vm_baseline.yaml`
- `docs/security/key_management.md`

### 5) Observability & Alerting
- `monitoring/prometheus/proxmox_pbs_targets.yml`
- `monitoring/alerts/proxmox_alert_rules.yml`
- `monitoring/grafana/dashboard_notes.md`
- `scripts/monitoring/status_dashboard.sh`

### 6) Networking Automation
- `templates/network/vlan_bond_bridge_example.conf`
- `templates/network/split_network_reference.yaml`
- `templates/network/traefik-compose.yml`
- `templates/network/nginx-compose.yml`
- `scripts/network_validate.sh`

### 7) Docker/LXC App Platform
- `install_docker_optimized.sh` with profiles: `default`, `ai`, `media`, `dev`, `db`
- Stack catalog: `docs/stacks/catalog.md`
- Compose references under `stacks/`

### 8) Validation & Safety
- `scripts/validation/preflight_checker.sh`
- `scripts/validation/compatibility_matrix.yaml`
- dry-run support in major scripts

### 9) Runbooks & Decision Guides
- `docs/runbooks/day0_day30.md`
- `docs/architecture/cluster_decision_guide.md`
- `docs/troubleshooting/playbooks.md`
- `docs/recipes/quick_recipes.md`

### 10) Quality & Community
- CI workflow: `.github/workflows/ci.yml`
- Issue templates in `.github/ISSUE_TEMPLATE/`
- `CONTRIBUTING.md`
- `TESTED_ENVIRONMENTS.md`

---

## Example Commands

```bash
# Validate host readiness
./scripts/cluster/preflight.sh

# Bootstrap first cluster node
./scripts/cluster/bootstrap_cluster.sh --cluster-name netics-ha --bindnet 10.10.10.0/24 --dry-run

# Generate HA groups
./scripts/ha/generate_ha_groups.sh

# Run global preflight checker
./scripts/validation/preflight_checker.sh --dry-run

# Install Docker profile for development workloads
./install_docker_optimized.sh --profile dev --dry-run
```

---

## License

MIT License - Free for personal and commercial use.
