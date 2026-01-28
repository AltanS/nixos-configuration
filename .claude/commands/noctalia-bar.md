---
name: noctalia-bar
description: Configure noctalia bar widgets
---

# Noctalia Bar Configuration

Manage the noctalia shell bar widget layout.

## Configuration Location

```
home/desktop/shell/noctalia/default.nix
```

## Bar Structure

```nix
bar = {
  position = "top";  # or "bottom"
  widgets = {
    left = [ ... ];
    center = [ ... ];
    right = [ ... ];
  };
};
```

**IMPORTANT:** Use `bar.widgets.left/center/right`, NOT `bar.widgetsLeft/Center/Right`.

## Widget Format

**All widgets MUST be objects with an `id` field.** Plain strings don't work.

```nix
# Minimal
{ id = "Clock"; }

# With settings
{
  id = "SystemMonitor";
  compactMode = false;
  showCpuUsage = true;
  showNetworkStats = true;
}
```

## Available Widgets

Launcher, ActiveWindow, Workspace, Clock, SystemMonitor, Tray, NotificationHistory, Battery, Volume, Brightness, MediaMini, ControlCenter

## Verification

After changes, verify the bar layout:
```bash
noctalia-shell ipc call state all | jq '.settings.bar.widgets'
```

## VM Workflow

```bash
./scripts/dev-sync rebuild && \
sshpass -p 'test' ssh altan@192.168.122.3 \
  'systemctl --user restart noctalia-shell && sleep 2 && noctalia-shell ipc call state all' | jq '.settings.bar.widgets'
```

## User Request

$ARGUMENTS
