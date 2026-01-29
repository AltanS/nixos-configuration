---
name: dev-sync
description: This skill should be used when the user asks to "sync to VM", "rebuild VM", "test on VM", "dev-sync", "push changes to VM", or wants to iterate on NixOS configuration using a VM. Covers the dev-sync workflow for rapid VM development.
---

# VM Development Workflow (dev-sync)

The `./scripts/dev-sync` script enables rapid iteration on NixOS configuration using a VM.

## Setup

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Configure VM connection in `.env`:
```
VM_HOST=192.168.122.3
VM_USER=altan
VM_PASS=test
```

## Commands

```bash
# Sync files only (no rebuild)
./scripts/dev-sync sync

# Sync + rebuild NixOS
./scripts/dev-sync rebuild

# Sync + run flake check
./scripts/dev-sync check

# Open SSH session to VM
./scripts/dev-sync ssh
```

## How It Works

1. **Rsyncs** files to `~/nixos-sync` on VM (as user)
2. **Sudo rsyncs** to `/etc/nixos` (preserves .git)
3. **Auto-commits** changes for flake compatibility
4. Runs requested command (rebuild, check, etc.)

## Important: Flake + Git

NixOS flakes require files to be git-tracked. The script:
- Preserves `.git` directory on VM
- Auto-initializes git repo if missing
- Auto-commits changes before rebuild

## Common Workflows

### Test configuration changes
```bash
# Make changes locally, then:
./scripts/dev-sync rebuild
```

### Restart services without logout
```bash
# After rebuild, restart specific service:
sshpass -p 'test' ssh altan@192.168.122.3 'systemctl --user restart noctalia-shell'
```

### Full test cycle
```bash
./scripts/dev-sync rebuild && \
sshpass -p 'test' ssh altan@192.168.122.3 'systemctl --user restart noctalia-shell'
```

### Check for errors before rebuild
```bash
./scripts/dev-sync check
```

## Verification Commands

Run on VM via SSH:

```bash
# Check service status
sshpass -p 'test' ssh altan@192.168.122.3 'systemctl --user status noctalia-shell'

# Check generated config
sshpass -p 'test' ssh altan@192.168.122.3 'cat ~/.config/noctalia/settings.json | jq .'

# Check noctalia runtime state
sshpass -p 'test' ssh altan@192.168.122.3 'noctalia-shell ipc call state all | jq .'
```

## Troubleshooting

### "path does not exist" errors
- Files must be git-tracked for flakes
- Script auto-commits, but check if new directories are added

### Build fails on VM but works locally
- VM may have different nixpkgs version
- Check flake.lock is synced

### Services not restarting
- Use `systemctl --user restart <service>`
- Or logout/login for full reload
