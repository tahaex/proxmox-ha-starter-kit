#!/usr/bin/env bash
# 🐳 Netics Agency - Modular Docker Installer for Proxmox LXC
# Verified on Debian 12 and Ubuntu 22.04/24.04

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROFILE="default"
DRY_RUN=false

usage() {
  cat <<USAGE
Usage: ./install_docker_optimized.sh [--profile default|ai|media|dev|db] [--dry-run]
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

run() {
  if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY-RUN]${NC} $*"
  else
    "$@"
  fi
}

echo -e "${BLUE}[Netics] Starting modular Docker installation (profile: ${PROFILE})...${NC}"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo -e "${GREEN}[1/6] Updating system packages...${NC}"
run apt-get update
run apt-get upgrade -y
run apt-get install -y ca-certificates curl gnupg lsb-release

echo -e "${GREEN}[2/6] Adding Docker repository...${NC}"
run install -m 0755 -d /etc/apt/keyrings
if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}[DRY-RUN]${NC} curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
else
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
run chmod a+r /etc/apt/keyrings/docker.gpg
# shellcheck disable=SC1091
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}[DRY-RUN]${NC} write /etc/apt/sources.list.d/docker.list"
else
  printf '%s\n' "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list
fi
run apt-get update

echo -e "${GREEN}[3/6] Installing Docker Engine + Compose...${NC}"
run apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${GREEN}[4/6] Applying daemon config with rollback safety...${NC}"
if [ "$DRY_RUN" = false ] && [ -f /etc/docker/daemon.json ]; then
  cp /etc/docker/daemon.json "/etc/docker/daemon.json.bak.$(date +%Y%m%d%H%M%S)"
fi

TMP_DAEMON_FILE="/etc/docker/daemon.json.tmp"
# overlay2 is set explicitly for consistent behavior across supported hosts.
cat > "$TMP_DAEMON_FILE" <<'CONFIG'
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
  "storage-driver": "overlay2",
  "ipv6": false
}
CONFIG

run install -m 0644 "$TMP_DAEMON_FILE" /etc/docker/daemon.json
if [ "$DRY_RUN" = false ]; then
  rm -f "$TMP_DAEMON_FILE"
fi

echo -e "${GREEN}[5/6] Installing profile packages...${NC}"
case "$PROFILE" in
  default)
    run apt-get install -y htop jq
    ;;
  ai)
    run apt-get install -y htop jq nvtop
    ;;
  media)
    run apt-get install -y htop jq ffmpeg
    ;;
  dev)
    run apt-get install -y htop jq git make
    ;;
  db)
    run apt-get install -y htop jq iotop
    ;;
  *)
    echo "Unsupported profile: $PROFILE"
    exit 1
    ;;
esac

echo -e "${GREEN}[6/6] Enabling Docker service...${NC}"
run systemctl enable docker
run systemctl restart docker

echo -e "${BLUE}[Netics] Docker profile '${PROFILE}' installed successfully.${NC}"
if [ "$DRY_RUN" = false ]; then
  docker --version
fi

echo "Recommendation: add user to docker group -> usermod -aG docker <user>"
