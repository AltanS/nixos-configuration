---
name: noctalia-bar
description: This skill should be used when the user asks to "move a widget", "add widget to bar", "remove widget from bar", "configure bar layout", "change bar position", "customize noctalia bar", or mentions bar widgets like Launcher, Clock, SystemMonitor, Workspace.
---

# Noctalia Bar Configuration

This skill manages the noctalia shell bar widget layout. For general noctalia patterns (IPC, debugging, restart), see the **noctalia** skill.

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

### Minimal widget
```nix
{ id = "Clock"; }
{ id = "Tray"; }
```

### Widget with settings
```nix
{
  id = "SystemMonitor";
  compactMode = false;
  showCpuUsage = true;
  showNetworkStats = true;
}
```

## Common Operations

### Move widget between zones
1. Read the config file
2. Find widget in current zone (left/center/right)
3. Remove from current zone, add to target zone
4. Preserve all widget settings if it's an object

### Add widget
Add `{ id = "WidgetName"; }` to desired zone array.

### Remove widget
Remove the widget object from its zone array.

## Verification

After changes, verify the bar layout:
```bash
noctalia-shell ipc call state all | jq '.settings.bar.widgets'
```

## Available Widgets

See `references/widgets.md` for complete list with all configurable settings.

## Important Notes

- Widget names are case-sensitive ("SystemMonitor" not "systemmonitor")
- Noctalia merges your settings with defaults for each widget
- Restart noctalia after rebuild: `systemctl --user restart noctalia-shell`
