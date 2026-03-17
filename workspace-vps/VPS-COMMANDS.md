# VPS Management Commands Reference

## System Monitoring
```bash
# System status
htop
df -h
free -h
systemctl status

# OpenClaw gateway status  
docker ps | grep openclaw
docker logs openclaw-gateway --tail 50

# Network connections
netstat -tulpn | grep :3210
ss -tulpn | grep :18789
```

## Container Management
```bash
# OpenClaw containers
docker-compose ps
docker-compose logs -f
docker-compose restart

# Container health
docker stats openclaw-gateway
docker exec -it openclaw-gateway ps aux
```

## Security Monitoring
```bash
# Failed login attempts
journalctl -u ssh -f | grep "Failed password"
fail2ban-client status sshd

# Firewall status
ufw status numbered
iptables -L -n
```

## Performance Optimization
```bash
# Memory usage
ps aux --sort=-%mem | head -10
docker system df
docker system prune -f

# Disk cleanup
apt autoremove -y
docker system prune -a -f
```

## Backup Operations
```bash
# Workspace backup
tar -czf backup-$(date +%Y%m%d).tar.gz workspace/
rsync -av workspace/ backup-location/

# Database backup (if applicable)
pg_dump openclaw > openclaw_backup_$(date +%Y%m%d).sql
```

This agent specializes in these operational tasks.