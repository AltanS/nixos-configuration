---
name: noctalia
description: This skill should be used when the user asks to "configure noctalia", "change noctalia settings", "debug noctalia", "restart noctalia", or mentions noctalia shell, quickshell, or noctalia IPC. Provides common patterns for working with noctalia shell in this NixOS config.
---

# Noctalia Shell Configuration

This skill provides common patterns for configuring and debugging the noctalia desktop shell.

## Configuration Location

```
home/desktop/shell/noctalia/default.nix
```

The nix config generates `~/.config/noctalia/settings.json` (symlinked to nix store).

## Key Concepts

### Settings Format
Noctalia settings are JSON. The nix home-module accepts freeform attributes that get serialized to JSON. Key gotcha: nested objects must match noctalia's expected structure exactly.

### Runtime State vs Config
- **settings.json** - What nix generates (read-only symlink)
- **Runtime state** - What noctalia is actually using (can differ if UI changes were made)
- Always verify runtime state via IPC after changes

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

### Changes not applying
1. Verify settings.json has correct content: `cat ~/.config/noctalia/settings.json`
2. Restart noctalia: `systemctl --user restart noctalia-shell`
3. Check runtime state matches: `noctalia-shell ipc call state all | jq`

### Wrong JSON structure
Noctalia expects specific nested structures. Example for bar widgets:
- **Wrong:** `bar.widgetsLeft = [...]`
- **Correct:** `bar.widgets.left = [...]`

### Widgets not appearing
All widgets must be objects with `id` field:
- **Wrong:** `"Clock"`
- **Correct:** `{ id = "Clock"; }`

## Related Skills

- **noctalia-bar** - Bar widget layout and settings

## External Resources

- Docs: https://docs.noctalia.dev/
- IPC docs: https://docs.noctalia.dev/development/plugins/ipc/
- GitHub: https://github.com/noctalia-dev/noctalia-shell
