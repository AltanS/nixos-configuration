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

## VM Testing

For testing on Fedora Silverblue with virt-manager, see **[docs/vm-testing.md](docs/vm-testing.md)**.

Quick start:
```bash
# Download ISO
curl -LO https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso

# Create VM in virt-manager with:
# - 4GB RAM, 4 CPUs, 20GB disk
# - Video: Virtio + 3D acceleration
# - Display: Spice, Listen=None, OpenGL enabled
# - Filesystem: virtiofs share to your config folder

# SSH into live ISO (easier than console)
ssh nixos@<vm-ip>  # after setting passwd in VM
```
