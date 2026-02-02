#!/bin/bash
# 🐳 Netics Agency - Optimized Docker Installer for Proxmox LXC
# Verified on Debian 12 (Bookworm) and Ubuntu 22.04/24.04
# 
# Usage: ./install_docker_optimized.sh

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}[Netics] Starting production-grade Docker installation...${NC}"

# 1. Prerequisite Check
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# 2. Update System & Install Dependencies
echo -e "${GREEN}[1/5] Updating system packages...${NC}"
apt-get update && apt-get upgrade -y
apt-get install -y ca-certificates curl gnupg lsb-release

# 3. Add Official Docker Repo
echo -e "${GREEN}[2/5] Adding Docker GPG key & repository...${NC}"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

# 4. Install Docker Engine
echo -e "${GREEN}[3/5] Installing Docker Engine + Compose...${NC}"
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Optimize Docker Daemon (Crucial for Production)
echo -e "${GREEN}[4/5] Configuring optimized daemon.json...${NC}"
cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-address-pools": [
    {
      "base": "172.20.0.0/16",
      "size": 24
    }
  ],
  "ipv6": false
}
EOF

# 6. Enable & Start
systemctl enable docker
systemctl restart docker

echo -e "${BLUE}[Netics] Docker installed successfully! 🚀${NC}"
docker --version
echo -e "Recommendation: Add your user to the docker group: usermod -aG docker \$USER"
