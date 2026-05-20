# Compose Stack Catalog

## Available reference stacks
- `stacks/monitoring-compose.yml` (Prometheus + Grafana)
- `stacks/backup-compose.yml` (restic reference)
- `stacks/reverse-proxy-compose.yml` (Caddy reverse proxy)
- `stacks/auth-compose.yml` (Authelia auth gateway)

## Notes
- Use these as baseline templates.
- Move secrets to environment files or secret managers.
- Run in isolated docker networks and expose only required ports.
