# Project Instructions

This is a NixOS configuration with modular WM/shell support.

## Architecture

The desktop environment is configurable per-host via `flake.nix`:

```nix
hosts = [
  { hostname = "vm"; desktop = { wm = "niri"; shell = "noctalia"; }; }
  { hostname = "thinkcentre"; desktop = { wm = "hyprland"; shell = "waybar"; }; }
];
```

### Directory Structure

```
home/desktop/
  wm/hyprland/     # Hyprland window manager config
  wm/niri/         # Niri window manager config
  shell/waybar/    # Waybar status bar
  shell/noctalia/  # Noctalia desktop shell
  shared/          # Shared components (rofi, swaync, gtk, wallpaper)

system/desktop/
  wm/hyprland.nix  # Hyprland system config
  wm/niri.nix      # Niri system config
  shell/noctalia.nix
  shared/          # Shared system config (audio, xdg portals)
```

## Implementation Notes

### niri-flake Integration

The `niri-flake.nixosModules.niri` module automatically provides home-manager integration. Do NOT also import `niri-flake.homeModules.niri` in your home config - this causes option conflicts:

```nix
# WRONG - causes duplicate option error
imports = [ inputs.niri-flake.homeModules.niri ];

# CORRECT - just use programs.niri.settings directly
programs.niri.settings = { ... };
```

### noctalia Requires Unstable

Noctalia depends on quickshell which is only in nixpkgs-unstable:

```nix
noctalia = {
  url = "github:noctalia-dev/noctalia-shell";
  inputs.nixpkgs.follows = "nixpkgs-unstable";  # NOT nixpkgs
};
```

### Conditional Shell Bindings

To add shell-specific keybindings in WM configs, define them separately and merge:

```nix
{ desktop, ... }:
let
  noctaliaBinds = {
    "Mod+Space".action.spawn = [ "qs" "-c" "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
  };
  waybarBinds = {
    "Mod+N".action.spawn = [ "swaync-client" "-t" ];
  };
  shellBinds = { noctalia = noctaliaBinds; waybar = waybarBinds; }.${desktop.shell};
in {
  programs.niri.settings.binds = {
    # ... common binds ...
  } // shellBinds;
}
```

### Avoid Duplicate Module Imports

Host configs should NOT directly import modules that are already imported by aggregators (`system/desktop/default.nix`). This can cause unexpected behavior:

```nix
# WRONG - greetd.nix is already imported via system/desktop
imports = [
  ../../system/desktop
  ../../system/desktop/greetd.nix  # duplicate!
];

# CORRECT
imports = [
  ../../system/desktop  # includes greetd.nix
];
```

### Relative Paths After Moving Files

When moving nix files to new directories, update relative paths:

```nix
# Before (in home/desktop/wallpaper.nix)
wallpaperDir = ../../assets/wallpapers;

# After (in home/desktop/shared/wallpaper.nix)
wallpaperDir = ../../../assets/wallpapers;  # one more level up
```

## Documentation References

### Niri (Scrollable Tiling Wayland Compositor)

- **NixOS Integration**: https://github.com/sodiboo/niri-flake
  - Provides `programs.niri.settings` for Nix-native configuration
  - NixOS module: `niri-flake.nixosModules.niri`
- **Configuration Docs**: https://github.com/YaLTeR/niri/wiki
  - Key bindings: https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings
  - Default config: https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl
- **Arch Wiki**: https://wiki.archlinux.org/title/Niri

Key niri concepts:
- `Mod` = Super on TTY, Alt in nested window
- `Mod+Shift+/` shows hotkey overlay
- Niri does NOT load default bindings - all binds must be explicit

### Noctalia Shell (Wayland Desktop Shell)

- **Documentation**: https://docs.noctalia.dev/
  - NixOS setup: https://docs.noctalia.dev/getting-started/nixos/
  - Keybinds: https://docs.noctalia.dev/getting-started/keybinds/
- **GitHub**: https://github.com/noctalia-dev/noctalia-shell
- **Requires**: nixpkgs-unstable (for quickshell dependency)

Key noctalia concepts:
- No built-in keybindings - configure in your WM
- IPC commands: `qs -c noctalia-shell ipc call <target> <action>`
  - `launcher toggle` - application launcher
  - `controlCenter toggle` - notifications & quick settings
  - `settings toggle` - settings panel

### Hyprland

- **Wiki**: https://wiki.hyprland.org/
- **NixOS Wiki**: https://wiki.nixos.org/wiki/Hyprland

### Waybar

- **GitHub**: https://github.com/Alexays/Waybar
- **Wiki**: https://github.com/Alexays/Waybar/wiki

## Keybinding Conventions

| Action | Hyprland | Niri |
|--------|----------|------|
| Terminal | Super+Q | Mod+T |
| App Launcher | Super+R | Mod+D |
| File Manager | Super+E | Mod+E |
| Close Window | Super+C / Alt+F4 | Mod+Q / Alt+F4 |
| Show Keybinds | Super+/ | Mod+Shift+/ |
| Notifications | Super+N | Mod+N |

## Development Workflow

### Fast VM Iteration (dev-sync)

Use `./scripts/dev-sync` for rapid development on a VM without git push/pull:

```bash
# Setup: configure VM connection
cp .env.example .env
# Edit .env with VM_HOST, VM_USER, VM_PASS

# Sync files to VM
./scripts/dev-sync sync

# Sync and rebuild NixOS
./scripts/dev-sync rebuild

# Sync and run flake check
./scripts/dev-sync check

# Open SSH session
./scripts/dev-sync ssh
```

The script:
1. Rsyncs files to `~/nixos-sync` on VM
2. Sudo rsyncs to `/etc/nixos`
3. Runs the requested command

### Manual Testing

Build without switching:
```bash
nix build .#nixosConfigurations.vm.config.system.build.toplevel
```

Check flake:
```bash
nix flake check
```

Rebuild and switch:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```
