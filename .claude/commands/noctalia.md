---
name: noctalia
description: Configure and debug noctalia shell
---

# Noctalia Shell Configuration

Use these patterns for configuring and debugging the noctalia desktop shell.

## Configuration Location

```
home/desktop/shell/noctalia/default.nix
```

The nix config generates `~/.config/noctalia/settings.json` (symlinked to nix store).

## IPC Commands

Query and control noctalia via IPC:

```bash
# Get full runtime state
noctalia-shell ipc call state all

# List available IPC targets
noctalia-shell ipc show

# Common targets
noctalia-shell ipc call launcher toggle
noctalia-shell ipc call controlCenter toggle
noctalia-shell ipc call settings toggle
noctalia-shell ipc call wallpaper random
```

## Debugging & Verification

### Check runtime state
```bash
noctalia-shell ipc call state all | jq '.settings'
```

### Check generated config
```bash
cat ~/.config/noctalia/settings.json | jq .
```

### Restart noctalia (apply changes without logout)
```bash
systemctl --user restart noctalia-shell
```

### VM workflow (rebuild + restart + verify)
```bash
./scripts/dev-sync rebuild && \
sshpass -p 'test' ssh altan@192.168.122.3 \
  'systemctl --user restart noctalia-shell && sleep 2 && noctalia-shell ipc call state all' | jq '.settings'
```

## Common Issues

### Wrong JSON structure
Noctalia expects specific nested structures. Example for bar widgets:
- **Wrong:** `bar.widgetsLeft = [...]`
- **Correct:** `bar.widgets.left = [...]`

### Widgets not appearing
All widgets must be objects with `id` field:
- **Wrong:** `"Clock"`
- **Correct:** `{ id = "Clock"; }`

## User Request

$ARGUMENTS
