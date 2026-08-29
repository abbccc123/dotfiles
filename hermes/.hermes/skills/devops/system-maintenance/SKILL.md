---
name: system-maintenance
description: Use for system health checks and Linux administration.
---

# System Maintenance Workflow

This skill defines the standard operating procedure for maintaining the user's Linux environment based on the installed toolset.

## 🛠️ Tool Inventory
The following tools are verified to be installed on the system:

- **Resource Monitoring**: `top`, `vmstat`, `free`, `uptime`
- **Disk & FS**: `df`, `du`, `lsblk`, `fdisk`, `parted`, `mount`, `umount`, `fsck`
- **Network**: `ip`, `netstat`, `ss`, `curl`, `wget`, `dig`, `nmcli`, `ping`
- **Process/Service**: `ps`, `kill`, `systemctl`, `journalctl`, `pgrep`, `pkill`
- **Pkg Manager**: `pacman` (Arch-based)
- **Core Utils**: `vim`, `nvim`, `tmux`, `screen`, `bash`, `git`, `ssh`, `scp`, `tar`, `gzip`, `find`, `grep`, `sed`, `awk`

## 🚀 Standard Procedures

### 1. Rapid Health Check
Perform a comprehensive system snapshot:
```bash
# Check CPU/Memory/Uptime
uptime && free -h && vmstat 1 5

# Check Disk Space and Mounts
df -h && lsblk -f

# Check Network Connectivity
ping -c 3 8.8.8.8 && ip a
```

### 2. Process & Service Troubleshooting
When a service is unresponsive or CPU is spiking:
1. **Identify**: `top` or `ps aux --sort=-%cpu | head -n 10`
2. **Analyze**: `journalctl -u <service_name> -n 50 --no-pager`
3. **Manage**: `systemctl status <service_name>` $\rightarrow$ `systemctl restart <service_name>`
4. **Force Kill**: `pgrep <name>` $\rightarrow$ `kill -9 <pid>`

### 3. Network Diagnostics
Verify connectivity and port status:
- **Interface State**: `ip a`
- **Listening Ports**: `ss -tulpn`
- **Route Analysis**: `ip route`
- **DNS Check**: `dig google.com`

### 4. Storage Maintenance
- **Find Large Files**: `du -ah /home | sort -rh | head -n 20`
- **Partition Inspection**: `lsblk -f`
- **Mount Verification**: `mount | grep /mnt/user_data`

## ⚠️ Pitfalls & Constraints
- **Sudo Requirements**: Commands like `fdisk`, `parted`, `systemctl` (for global services), and `fsck` require root privileges.
- **Disk Quotas**: Be mindful of `/home` vs `/mnt/user_data` usage.
- **Service Impact**: Using `kill -9` on system services can leave stale lock files; prefer `systemctl stop`.

## ✅ Verification
A maintenance task is considered complete when:
1. The target metric (CPU/Disk/Network) has returned to the expected baseline.
2. `systemctl status` reports the service as `active (running)`.
3. No new errors appear in `journalctl -p 3 -xb`.
