# NixOS Configuration

Flake-based NixOS configuration with Hyprland.

## Structure

```
.
├── flake.nix           # Entry point
├── hosts/              # Machine-specific configs
│   ├── vm/             # QEMU/KVM test VM
│   └── thinkcentre/    # Physical desktop
├── system/             # NixOS modules
│   ├── core/           # Nix, boot, locale, users
│   ├── desktop/        # Hyprland, audio, greetd
│   └── hardware/       # VM, Intel, Bluetooth
├── home/               # Home Manager modules
│   ├── desktop/        # Hyprland, waybar, rofi
│   ├── terminal/       # kitty, bat
│   └── apps/           # git, ssh, packages
└── users/              # User data (git email, SSH keys)
```

## Usage

```bash
# Build and switch to a NixOS configuration
sudo nixos-rebuild switch --flake .#vm
sudo nixos-rebuild switch --flake .#thinkcentre

# Build VM for testing (runs in QEMU)
nix build .#vm
./result/bin/run-vm-vm

# Standalone home-manager (non-NixOS systems)
nix run home-manager -- switch --flake .#altan
```

## First Time Setup

```bash
# Install git
nix-env -iA nixos.git

# Set up SSH key
cp /path/to/key ~/.ssh/a.sarisin
chmod 600 ~/.ssh/a.sarisin
ssh-add ~/.ssh/a.sarisin
ssh -T git@github.com

# Clone and apply
git clone git@github.com:AltanS/nixos-configuration.git
cd nixos-configuration
sudo nixos-rebuild switch --flake .#vm  # or .#thinkcentre

# Add new host
sudo nixos-generate-config --show-hardware-config > hosts/NEW_HOST/hardware.nix
```

## Hosts

| Host | Description | Display Manager |
|------|-------------|-----------------|
| `vm` | QEMU/KVM test VM | greetd + tuigreet |
| `thinkcentre` | Physical desktop | GDM + GNOME |
