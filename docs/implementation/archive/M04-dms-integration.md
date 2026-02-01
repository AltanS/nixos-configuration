# M04: DMS (DankMaterialShell) Integration

**Status:** Complete
**Priority:** High
**Created:** 2026-02-01

## Objective

Add DankMaterialShell v1.2 as a third desktop shell option alongside noctalia and waybar. Integrate with niri window manager, switch VM to DMS for testing. Includes bumping nixpkgs and home-manager to unstable/master to satisfy DMS dependencies.

## Specs

### S01: Flake Inputs & Nixpkgs Upgrade ✓
- [x] Add DMS flake input (`github:AvengeMedia/DankMaterialShell/stable`)
- [x] Add DMS plugin registry input (`github:AvengeMedia/dms-plugin-registry`)
- [x] Bump nixpkgs from `nixos-24.11` to `nixos-unstable` (required by HM master)
- [x] Bump home-manager to master (required by DMS `programs.quickshell` module)
- [x] Remove separate `nixpkgs-unstable` input (now redundant)
- [x] Remove `pkgs-unstable` extraSpecialArg

**Files:**
- `flake.nix`

### S02: Shell Module Integration ✓
- [x] Create `home/desktop/shell/dms/default.nix` (home-manager config)
- [x] Create `system/desktop/shell/dms.nix` (NixOS system config)
- [x] Add `dms` to shell dispatch map in `home/desktop/default.nix`
- [x] Add `dms` to shell dispatch map in `system/desktop/default.nix`
- [x] Add `qtwayland` to DMS home packages (missing from DMS quickshell closure)
- [x] Do NOT import `dms.homeModules.niri` (conflicts with niri-flake by injecting KDL includes)

**Files:**
- `home/desktop/shell/dms/default.nix` (new)
- `system/desktop/shell/dms.nix` (new)
- `home/desktop/default.nix`
- `system/desktop/default.nix`

### S03: Niri Keybindings ✓
- [x] Add DMS spawn command (`dms run`) to niri shell dispatch
- [x] Add DMS IPC keybindings: Ctrl+R (spotlight), Mod+N (notifications), Mod+I (settings)
- [x] Add DMS spawn fallback in Hyprland settings

**Files:**
- `home/desktop/wm/niri/default.nix`
- `home/desktop/wm/hyprland/settings.nix`

### S04: Nixpkgs-Unstable Package Fixes ✓
- [x] Fix `nerdfonts` → `nerd-fonts.jetbrains-mono` rename
- [x] Remove `libsForQt5.xwaylandvideobridge` (removed from unstable)
- [x] Fix `pkgs.greetd.tuigreet` → `pkgs.tuigreet` rename
- [x] Migrate `programs.git.userName`/`userEmail`/`extraConfig` to `settings.*` API
- [x] Migrate `programs.ssh.addKeysToAgent`/`extraConfig` to `matchBlocks."*"` API
- [x] Remove `nixpkgs.config.allowUnfreePredicate` from home-manager (redundant with `useGlobalPkgs`)

**Files:**
- `home/apps/packages.nix`
- `home/apps/git.nix`
- `home/apps/ssh.nix`
- `home/default.nix`
- `system/desktop/greetd.nix`

### S05: Qt Theme Wayland Fix ✓
- [x] Change `qt.platformTheme.name` from `"gtk"` to `"adwaita"` (GTK2 theme crashes on pure Wayland)
- [x] Add `style.name = "adwaita-dark"` to match GTK theme

**Files:**
- `home/desktop/shared/gtk.nix`

### S06: VM Infrastructure ✓
- [x] Resize VM disk from 20GB to 40GB (nixpkgs-unstable upgrade needed more space)
- [x] Switch VM host from `shell = "noctalia"` to `shell = "dms"`

## Verification

- [x] `nix build` succeeds with no errors
- [x] `nixos-rebuild switch` completes without warnings
- [x] DMS service starts and stays running (`systemctl --user status dms.service`)
- [x] DMS bar visible on screen
- [x] Ctrl+R opens spotlight launcher
- [x] Mod+N opens notifications panel
- [x] Mod+I opens settings panel

## Dependencies

- M03: Terminal Tools (complete)

## Notes

- DMS bundles its own quickshell build which lacks `qtwayland` in its closure; we add it via `home.packages`
- DMS's `homeModules.niri` injects KDL `include` directives that conflict with niri-flake's config management
- The `qt.platformTheme.name = "gtk"` → `"adwaita"` change affects ALL Qt apps, not just DMS; this is correct for a pure Wayland session
- Noctalia input remains in `flake.nix` for easy rollback or use on other hosts
- VM disk: libvirt name is `nixos`, disk at `/var/lib/libvirt/images/nixos.qcow2`
