# VM Testing Guide

Test and iterate on this NixOS configuration using a QEMU/KVM VM on Fedora Silverblue.

## Prerequisites

- virt-manager installed (`rpm-ostree install virt-manager`)
- NixOS minimal ISO downloaded
- Config pushed to GitHub

```bash
curl -LO https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso
```

## VM Creation (virt-manager)

### Step 1: New VM Wizard

1. File → New Virtual Machine
2. Local install media → Browse to NixOS ISO
3. OS: Select "Generic Linux 2022" (or detect automatically)
4. RAM: 4096 MB, CPUs: 4
5. Storage: Create 20+ GB disk
6. **☑️ Check "Customize configuration before install"** ← Important!
7. Click Finish

### Step 2: Customize Before Install

In the configuration window that opens:

**Boot Options:**
- ☑️ Enable boot menu
- Boot order: CDROM first, then VirtIO Disk

**Video:**
- Model: Virtio
- 3D acceleration: ✓ Enabled

**Display:**
- Type: Spice
- Listen type: **None** (not "Address" - this is required for OpenGL)
- OpenGL: ✓ Enabled

> ⚠️ If you get "SPICE GL support is local-only and incompatible with -spice port/tls-port",
> the Listen type is wrong. It must be "None", not an address or network.

Click **Begin Installation** to start the VM.

## SSH Access (Recommended)

The VM console is awkward. SSH in from your host instead:

```bash
# In VM console, set a password and get IP
passwd                    # set simple password like "test"
ip a | grep 192           # note the IP (e.g., 192.168.122.x)

# From your host terminal
ssh nixos@192.168.122.x   # use the password you set
```

Now you can copy-paste commands easily.

## Installation

### Step 1: Partition and Format

```bash
# Partition disk (GPT with BIOS boot + root)
sudo parted -s /dev/vda -- mklabel gpt
sudo parted -s /dev/vda -- mkpart bios_grub 1MB 2MB
sudo parted -s /dev/vda -- set 1 bios_grub on
sudo parted -s /dev/vda -- mkpart root ext4 2MB 100%

# Format root partition
sudo mkfs.ext4 -L nixos /dev/vda2
```

> Note: The VM uses BIOS boot with GRUB, not UEFI. The 1MB bios_grub partition
> allows GRUB to install on GPT disks.

### Step 2: Mount Filesystems

```bash
sudo mount /dev/disk/by-label/nixos /mnt
```

### Step 3: Clone Configuration

```bash
git clone https://github.com/AltanS/nixos-configuration.git /mnt/etc/nixos
```

### Step 4: Install NixOS

```bash
sudo nixos-install --flake /mnt/etc/nixos#vm --no-root-passwd
```

This will take a while as it downloads and builds packages.

### Step 5: Reboot

```bash
# Remove ISO from boot order in virt-manager first, then:
sudo reboot
```

## Post-Install

After reboot, greetd should auto-login to Hyprland.

**Test keybindings:**
- `Super+Q` - Open kitty terminal
- `Super+R` - Open rofi launcher
- `Super+1-9` - Switch workspaces
- `Super+C` - Close window

## Iterating on Configuration

The config is in `/etc/nixos`. To apply changes:

```bash
cd /etc/nixos
git pull                                    # get latest changes
sudo nixos-rebuild switch --flake .#vm      # apply
```

Or edit locally on your host, push, then pull inside VM.

## Troubleshooting

### "No bootable device" after reboot

The ISO is still first in boot order. In virt-manager:
1. Shut down VM
2. View → Details → Boot Options
3. Move VirtIO Disk above CDROM (or remove CDROM)
4. Start VM

### Black screen / No Hyprland

Check if VirtIO 3D is working:
```bash
glxinfo | grep -i renderer   # Should show "virgl"
```

If not, verify virt-manager Video settings have 3D acceleration enabled.

### greetd not starting

Check logs:
```bash
journalctl -u greetd
```

### SSH connection refused after install

The installed system has SSH enabled. Find the new IP:
```bash
# In VM console
ip a | grep 192
```

Then SSH with your configured user:
```bash
ssh altan@192.168.122.x
```
