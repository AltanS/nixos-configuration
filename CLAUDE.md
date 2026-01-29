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
home/
  desktop/
    wm/hyprland/     # Hyprland window manager config
    wm/niri/         # Niri window manager config
    shell/waybar/    # Waybar status bar
    shell/noctalia/  # Noctalia desktop shell
    shared/          # Shared components (rofi, swaync, gtk, wallpaper)
  terminal/          # Terminal emulators and CLI tools
    ghostty.nix      # Ghostty terminal config
    kitty.nix        # Kitty terminal config
    starship.nix     # Starship prompt
    atuin.nix        # Shell history
    cli-tools.nix    # CLI utilities (bat, eza, etc.)
    dev-tools.nix    # Development tools (git, direnv)

system/
  base/              # Core system config (shared by all hosts)
    default.nix      # Aggregates base modules
    nix.nix          # Nix settings (flakes, gc, etc.)
    boot.nix         # Boot configuration
    networking.nix   # Network settings
    users.nix        # User accounts
  desktop/           # Desktop environment system config
    wm/hyprland.nix  # Hyprland system config
    wm/niri.nix      # Niri system config
    shell/noctalia.nix
    shared/          # Shared (audio, xdg portals)
  hardware/          # Hardware-specific modules
    qemu.nix         # QEMU/KVM VM settings
  profiles/          # Bundles of modules for host types
    desktop.nix      # Desktop profile (base + desktop)
  services/          # System services
    docker.nix       # Docker with compose

hosts/
  vm/                # VM-specific config
  thinkcentre/       # ThinkCentre-specific config
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

### noctalia Requires Unstable + quickshell in PATH

Noctalia depends on quickshell which is only in nixpkgs-unstable:

```nix
# flake.nix
noctalia = {
  url = "github:noctalia-dev/noctalia-shell";
  inputs.nixpkgs.follows = "nixpkgs-unstable";  # NOT nixpkgs
};
```

Additionally, the `qs` command (quickshell) must be in PATH for IPC commands to work (launcher, control center, etc.):

```nix
# home/desktop/shell/noctalia/default.nix
{ pkgs-unstable, ... }: {
  home.packages = [ pkgs-unstable.quickshell ];
}
```

Pass `pkgs-unstable` via `extraSpecialArgs` in flake.nix:

```nix
pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
```

### Conditional Shell Bindings

To add shell-specific keybindings in WM configs, define them separately and merge:

```nix
{ desktop, ... }:
let
  noctaliaBinds = {
    "Mod+Space".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
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

### VM SSH Commands

When running SSH commands to the VM, use sshpass to avoid interactive password prompts:

```bash
# Use sshpass with the VM password from .env
sshpass -p 'test' ssh altan@192.168.122.114 'command here'

# For interactive shells
sshpass -p 'test' ssh -t altan@192.168.122.114 'bash -ic "type cat"'
```

### Relative Paths After Moving Files

When moving nix files to new directories, update relative paths:

```nix
# Before (in home/desktop/wallpaper.nix)
wallpaperDir = ../../assets/wallpapers;

# After (in home/desktop/shared/wallpaper.nix)
wallpaperDir = ../../../assets/wallpapers;  # one more level up
```

### Adding System Services

System services live in `system/services/`. Example adding Docker:

```nix
# system/services/docker.nix
{ pkgs, user, ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  users.users.${user}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}
```

Then import in host config:
```nix
# hosts/vm/default.nix
imports = [
  ../../system/profiles/desktop.nix
  ../../system/services/docker.nix
];
```

### niri Client-Side Decorations (CSD)

To allow apps like Ghostty to show their own title bars:

```nix
# home/desktop/wm/niri/default.nix
programs.niri.settings = {
  prefer-no-csd = false;  # Allow apps to draw their own decorations
};
```

Set to `true` to force server-side decorations (no app title bars).

### Ghostty Terminal Configuration

Ghostty config via home-manager:

```nix
# home/terminal/ghostty.nix
{ pkgs, ... }: {
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    font-size = 12
    gtk-titlebar = true
    gtk-single-instance = true
    theme = catppuccin-mocha
    background-opacity = 0.95
    shell-integration = detect
    shell-integration-features = cursor,sudo,title
    window-subtitle = working-directory  # Show PWD in title bar
  '';
}
```

Key settings:
- `window-subtitle = working-directory` - Shows current directory in window subtitle
- `gtk-titlebar = true` - Shows GTK header bar (requires niri `prefer-no-csd = false`)
- `shell-integration-features` - Enable cursor tracking, sudo detection, title updates

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

**niri-unstable vs stable:**

- `niri-unstable` has overview feature (`toggle-overview`) but has VM compatibility issues
- VMs use stable niri; real hardware uses unstable (controlled by `hostname != "vm"`)
- See: https://github.com/Smithay/smithay/issues/1415

### Noctalia Shell (Wayland Desktop Shell)

- **Documentation**: https://docs.noctalia.dev/
  - NixOS setup: https://docs.noctalia.dev/getting-started/nixos/
  - Keybinds: https://docs.noctalia.dev/getting-started/keybinds/
  - IPC docs: https://docs.noctalia.dev/development/plugins/ipc/
- **GitHub**: https://github.com/noctalia-dev/noctalia-shell
- **Reference Config**: https://github.com/argosnothing/nixos-config (see `modules/features/gui/wms/desktop-shells/noctalia-shell.nix`)
- **Requires**: nixpkgs-unstable (for quickshell dependency)

Key noctalia concepts:

- No built-in keybindings - configure in your WM
- IPC commands: `noctalia-shell ipc call <target> <action>`
  - `launcher toggle` - application launcher
  - `controlCenter toggle` - notifications & quick settings
  - `settings toggle` - settings panel
- The noctalia-shell package wraps quickshell internally - no need to add quickshell to home.packages separately

### Hyprland

- **Wiki**: https://wiki.hyprland.org/
- **NixOS Wiki**: https://wiki.nixos.org/wiki/Hyprland

### Waybar

- **GitHub**: https://github.com/Alexays/Waybar
- **Wiki**: https://github.com/Alexays/Waybar/wiki

### Profiles Pattern

Profiles bundle related modules for host types:

```nix
# system/profiles/desktop.nix
{ ... }: {
  imports = [
    ../base      # Core system (nix, boot, networking, users)
    ../desktop   # Desktop environment (WM, audio, portals)
  ];
}
```

Host configs use profiles:
```nix
# hosts/vm/default.nix
imports = [
  ./hardware.nix
  ../../system/profiles/desktop.nix  # Gets base + desktop
  ../../system/hardware/qemu.nix
  ../../system/services/docker.nix
];
```

## Keybinding Conventions

| Action             | Hyprland         | Niri                    |
| ------------------ | ---------------- | ----------------------- |
| Terminal           | Super+Q          | Ctrl+Alt+T              |
| App Launcher       | Super+R          | Ctrl+R                  |
| File Manager       | Super+E          | Mod+E                   |
| Close Window       | Super+C / Alt+F4 | Alt+Q / Alt+F4          |
| Show Keybinds      | Super+/          | Mod+Shift+/             |
| Keybind Cheatsheet | -                | Mod+F1 (noctalia)       |
| Overview           | -                | Mod+Tab (unstable only) |
| Notifications      | Super+N          | Mod+N                   |
| Settings (noctalia)| -                | Mod+I                   |

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

### Restart Services Without Logout

After rebuilding, restart desktop services to see changes immediately:

```bash
# Restart noctalia shell (bar, launcher, control center)
systemctl --user restart noctalia-shell

# Via SSH to VM
sshpass -p 'test' ssh altan@192.168.122.3 'systemctl --user restart noctalia-shell'
```
