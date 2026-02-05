# 🐳 Proxmox High-Availability Starter Kit
## Production-Grade Infrastructure Automation

<p align="center">
  <strong>Sovereign Infrastructure: Own Your Data, Control Your Costs</strong><br>
  <em>Battle-tested configurations from the Netics Engineering Team</em>
</p>

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Repository Contents](#repository-contents)
3. [Quick Start](#quick-start)
4. [Docker LXC Bootstrap](#docker-lxc-bootstrap)
5. [Backup Strategy Configuration](#backup-strategy-configuration)
6. [Architecture Reference](#architecture-reference)
7. [Troubleshooting](#troubleshooting)

---

## Overview

This repository contains **production-grade configuration templates** and **automation scripts** used at Netics Agency to deploy robust, self-healing on-premise infrastructure.

### Why Sovereign Infrastructure?

| Benefit | Description |
|---------|-------------|
| 🔒 **Data Ownership** | Your data never leaves your premises |
| 💰 **Cost Control** | No recurring cloud fees |
| ⚡ **Performance** | Local hardware = zero network latency |
| 🛡️ **Uptime** | 99.9% availability with proper HA setup |

---

## Repository Contents

| File | Description | Use Case |
|------|-------------|----------|
| `install_docker_optimized.sh` | **One-click Docker CT setup** | Fresh Debian/Ubuntu LXC containers |
| `backup_strategy.yaml` | **PBS retention policies** | Proxmox Backup Server configuration |
| `ha_groups_template.txt` | **HA Group definitions** | Failover priority configuration |

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/tahaex/proxmox-ha-starter-kit.git
cd proxmox-ha-starter-kit

# Make scripts executable
chmod +x *.sh
```

---

## Docker LXC Bootstrap

### Purpose
Transforms a fresh Debian/Ubuntu LXC container into a production-ready Docker host with optimized configurations for AI workloads.

### Usage

```bash
# Run inside your LXC container as root
./install_docker_optimized.sh
```

### What It Does (Step-by-Step)

```
┌─────────────────────────────────────────────────────────────────┐
│                    INSTALLATION PIPELINE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [1] System Update      →  apt-get update && upgrade             │
│           ↓                                                       │
│  [2] Dependencies       →  ca-certificates, curl, gnupg          │
│           ↓                                                       │
│  [3] Docker GPG Key     →  Official Docker repository            │
│           ↓                                                       │
│  [4] Docker Install     →  docker-ce, compose, buildx            │
│           ↓                                                       │
│  [5] Daemon Config      →  Optimized daemon.json                 │
│           ↓                                                       │
│  [6] Enable & Start     →  systemctl enable docker               │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Daemon Configuration Explained

The script creates an optimized `/etc/docker/daemon.json`:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",    // Prevents disk overflow
    "max-file": "3"       // Rotate logs (keep max 3)
  },
  "default-address-pools": [
    {
      "base": "172.20.0.0/16",  // Custom subnet (avoids conflicts)
      "size": 24
    }
  ],
  "ipv6": false  // Disabled for simplicity
}
```

**Why These Settings?**

| Setting | Problem Solved |
|---------|---------------|
| `max-size: 10m` | Prevents container logs from filling up disk |
| `max-file: 3` | Automatic log rotation |
| `base: 172.20.0.0/16` | Avoids IP conflicts with typical LAN ranges |
| `ipv6: false` | Simplifies networking in most homelab setups |

---

## Backup Strategy Configuration

### Purpose
Defines retention and encryption policies for Proxmox Backup Server (PBS).

### The Grandfather-Father-Son Strategy

```yaml
# Retention Policy Visualization
#
#   [Hourly]     [Daily]      [Weekly]     [Monthly]    [Yearly]
#      ↓            ↓            ↓             ↓            ↓
#   keep-last:3  keep-daily:7  keep-weekly:4  keep-monthly:12  keep-yearly:5
#      │            │            │             │            │
#   Last 3       7 days       4 weeks      12 months     5 years
#   snapshots
```

### Configuration Breakdown

```yaml
datastore: production-backups
  path: /mnt/datastore/production-backups
  
  # 🔒 Automatic Pruning
  prune-schedule: daily
  
  # 📅 Retention Policy
  keep-last: 3      # Immediate recovery (last 3 backups)
  keep-daily: 7     # One week of daily backups
  keep-weekly: 4    # One month of weekly backups
  keep-monthly: 12  # One year of monthly archives
  keep-yearly: 5    # Five years of yearly archives
  
  # 🛡️ Encryption (AES-256-GCM)
  encryption:
     mode: encrypt
     key-file: /etc/proxmox-backup/encryption-key.json
```

### Verification Schedule

```yaml
verify-schedule:
  schedule: "sun 02:00"  # Every Sunday at 2 AM
```

**Why Verify?**
- Detects bit-rot before you need to restore
- Ensures backups are actually readable
- Runs during low-usage hours

### Offsite Replication

```yaml
sync-job: offsite-cloud
  remote: netics-cloud-pbs
  remote-store: offsite-01
  schedule: "daily 04:00"  # After verification completes
```

---

## Architecture Reference

### Recommended 3-Node Cluster

```
┌─────────────────────────────────────────────────────────────────┐
│                    NETICS HA CLUSTER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│   │   Node 1    │    │   Node 2    │    │   Node 3    │         │
│   │  (Primary)  │    │ (Secondary) │    │  (Witness)  │         │
│   │   PVE 8.x   │◄──►│   PVE 8.x   │◄──►│   PVE 8.x   │         │
│   └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│          │                  │                  │                 │
│          └──────────────────┼──────────────────┘                 │
│                             │                                    │
│                      ┌──────┴──────┐                             │
│                      │ Ceph Storage │                            │
│                      │   (3 OSDs)   │                            │
│                      └─────────────┘                             │
│                                                                   │
│   Networking: LACP Bonds (10Gbps)                                │
│   Storage: Ceph RBD / ZFS Replication                            │
│   Proxy: Traefik + Let's Encrypt                                 │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### HA Priority Groups

```
Essential Services (Migrate First):
  - Database Servers
  - n8n / Workflow Engines
  - Reverse Proxies
  
Background Services (Migrate Last):
  - Backup Jobs
  - Dev/Test Containers
  - Monitoring Agents
```

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Docker install fails | Missing dependencies | Run `apt-get update` first |
| Container networking broken | IP conflict | Change `base` in daemon.json |
| PBS verification fails | Corrupted backup | Check disk health with `smartctl` |
| HA failover slow | Too many VMs in "Essential" | Reorganize HA groups |

### Logs to Check

```bash
# Docker daemon logs
journalctl -u docker -f

# PBS logs
journalctl -u proxmox-backup -f

# Cluster status
pvecm status
```

---

## 📜 License

MIT License - Free for personal and commercial use.

---

<p align="center">
  <strong>Maintained by Netics Engineering Team</strong><br>
  <a href="https://netics.fr">netics.fr</a>
</p>
