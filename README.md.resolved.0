# 🛡️ Proxmox High-Availability Starter Kit
> **Standardized Infrastructure Configurations by [Netics Agency](https://netics.agency)**

![Netics Banner](https://netics.agency/netics_logo_dark.svg) 
*(Replace with your actual banner if available)*

## 🚀 Overview
This repository contains the **production-grade configuration templates** and **automation scripts** we use at Netics Agency to deploy robust, self-healing on-premise infrastructure.

We believe in **Sovereign Infrastructure**: owning your data, controlling your costs, and ensuring 99.9% uptime without breaking the bank on cloud fees.

## 📦 What's Inside?

| Generic File | Description |
| :--- | :--- |
| `install_docker_optimized.sh` | **One-click Docker CT setup**. Includes ZFS tuning, Log rotation, and tailored Daemon configs for AI workloads. |
| `backup_strategy.yaml` | **PBS (Proxmox Backup Server) Config**. Retention policies (keep-last/daily/weekly) and encryption standards. |
| `ha_groups_template.txt` | **HA Group Logic**. Define 'Essential' vs 'Background' workloads to prioritize during failover. |

## 🛠️ Usage

### 1. Optimized Docker LXC Bootstrap
Run this script inside a fresh Debian/Ubuntu LXC container to prepare it for high-load production use.

```bash
chmod +x install_docker_optimized.sh
./install_docker_optimized.sh
```

### 2. Backup Policy (Reference)
Use the `backup_strategy.yaml` as a template for your `/etc/proxmox-backup/datastore.cfg` to ensure you never lose data.

## 🏗️ The Netics Architecture
We typically deploy this stack on a **3-Node Cluster** (PVE 8.x) with Ceph storage.
*   **Networking**: LACP Bonds (Broadcast + Migration split).
*   **Storage**: Ceph / ZFS Replication (15min sync).
*   **Proxy**: Traefik or Caddy for automatic SSL termination.

## 🤝 Contributing
Issues and Pull Requests are welcome. This is a living document of our best practices.

## 📜 License
MIT License. Free to use for your own Homelab or Enterprise setup.

---
*Built with ❤️ by the Netics Engineering Team.*
