# M01: VM Hyprland Setup

**Status:** 🔄 In Progress
**Priority:** High
**Created:** 2026-01-22

## Objective

Restructure NixOS configuration with clean folder layout, then fix issues to get Hyprland running in a QEMU/KVM VM on Fedora Silverblue.

## New Folder Structure

```
nixos-configuration/
├── flake.nix
│
├── hosts/
│   ├── vm/
│   │   ├── default.nix
│   │   └── hardware.nix
│   └── thinkcentre/
│       ├── default.nix
│       └── hardware.nix
│
├── system/                     # NixOS modules
│   ├── core/
│   │   ├── default.nix
│   │   ├── nix.nix
│   │   ├── boot.nix
│   │   └── locale.nix
│   ├── desktop/
│   │   ├── default.nix
│   │   ├── hyprland.nix
│   │   ├── greetd.nix
│   │   └── audio.nix
│   └── hardware/
│       ├── vm.nix
│       ├── intel.nix
│       └── bluetooth.nix
│
├── home/                       # Home Manager modules
│   ├── default.nix
│   ├── desktop/
│   │   ├── default.nix
│   │   ├── hyprland/
│   │   │   ├── default.nix
│   │   │   ├── settings.nix
│   │   │   └── binds.nix
│   │   ├── waybar.nix
│   │   ├── swaync.nix
│   │   └── rofi.nix
│   ├── terminal/
│   │   ├── default.nix
│   │   ├── kitty.nix
│   │   └── bat.nix
│   └── apps/
│       ├── default.nix
│       ├── git.nix
│       ├── ssh.nix
│       └── packages.nix
│
├── users/
│   └── altan.nix
│
└── docs/
    └── implementation/
```

## Specs

### Phase 0: Restructure
- [x] **S00** Create new folder structure
- [x] **S01** Migrate system modules to `system/`
- [x] **S02** Migrate home modules to `home/`
- [x] **S03** Move user data to `users/`
- [x] **S04** Update flake.nix for new paths
- [x] **S05** Delete old folders

### Phase 1: Fix Critical Issues
- [x] **S06** Make boot.nix use `lib.mkDefault`
- [x] **S07** Fix UWSM/HM systemd conflict (set `systemd.enable = false`)
- [x] **S08** Update VM to use VirtIO driver
- [x] **S09** Fix deprecated `mesa.drivers` → `mesa`
- [x] **S10** Clean up software rendering env vars

### Phase 2: VM Display
- [x] **S11** Create `system/desktop/greetd.nix`
- [x] **S12** Update VM host to use greetd instead of GDM

### Phase 3: VM Build Target
- [x] **S13** Add `packages.x86_64-linux.vm` to flake.nix
- [ ] **S14** Test full boot → Hyprland → waybar → kitty

## File Migration Map

| Old Location | New Location |
|--------------|--------------|
| `modules/audio.nix` | `system/desktop/audio.nix` |
| `modules/bluetooth.nix` | `system/hardware/bluetooth.nix` |
| `modules/boot.nix` | `system/core/boot.nix` |
| `modules/display.nix` | `system/desktop/` (split) |
| `modules/hyprland.nix` | `system/desktop/hyprland.nix` |
| `modules/nix.nix` | `system/core/nix.nix` |
| `modules/timezone.nix` | `system/core/locale.nix` |
| `modules/user.nix` | `system/core/user.nix` |
| `modules/home-manager.nix` | Integrated into flake |
| `home-manager/modules/hyprland/` | `home/desktop/hyprland/` |
| `home-manager/modules/waybar/` | `home/desktop/waybar.nix` |
| `home-manager/modules/kitty.nix` | `home/terminal/kitty.nix` |
| `home-manager/modules/rofi.nix` | `home/desktop/rofi.nix` |
| `home-manager/modules/swaync/` | `home/desktop/swaync.nix` |
| `home-manager/modules/git.nix` | `home/apps/git.nix` |
| `home-manager/modules/ssh.nix` | `home/apps/ssh.nix` |
| `home-manager/modules/bat.nix` | `home/terminal/bat.nix` |
| `home-manager/modules/home-packages.nix` | `home/apps/packages.nix` |
| `home-manager/users/altan.nix` | `users/altan.nix` |
| `home-manager/home.nix` | `home/default.nix` |
| `hosts/nixos-vm-conqueror/` | `hosts/vm/` |

## Verification

- [ ] `nix flake check` passes
- [ ] VM boots successfully with GRUB
- [ ] greetd auto-logs into Hyprland
- [ ] Hyprland starts with VirtIO-GPU
- [ ] waybar displays at top
- [ ] Super+Q opens kitty terminal

## Reference Code

### boot.nix with mkDefault
```nix
{ lib, ... }: {
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}
```

### Disable HM systemd (UWSM handles it)
```nix
wayland.windowManager.hyprland = {
  enable = true;
  systemd.enable = false;
};
```

### greetd.nix
```nix
{ pkgs, user, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
      initial_session = {
        command = "Hyprland";
        user = user;
      };
    };
  };
}
```

### QEMU flags for Hyprland
```bash
qemu-system-x86_64 \
  -enable-kvm -m 4G -smp 4 \
  -device virtio-vga-gl \
  -display gtk,gl=on \
  -device virtio-keyboard \
  -device virtio-mouse \
  -drive file=nixos.qcow2,format=qcow2,if=virtio
```
