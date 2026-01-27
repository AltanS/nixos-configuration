# M02: Desktop Polish

**Status:** Complete
**Priority:** Medium
**Created:** 2026-01-23
**Completed:** 2026-01-27

## Objective

Polish the Hyprland desktop experience with proper application launcher theming, default application configuration, keyboard layout support, and improved Waybar icons.

## Specs

### S01: Application Launcher (Rofi) ✅
- [x] Configure rofi as the application launcher
- [x] Apply consistent theming (colors, fonts, borders)
- [x] Set up drun mode for launching applications
- [x] Configure window switcher mode
- [x] Add keybinding in Hyprland (Super+R)

**Files:**
- `home/desktop/shared/rofi.nix`
- `home/desktop/hyprland/binds.nix`

### S02: Default Apps Configuration ✅
Default apps configured via WM settings:
- [x] File manager: Nautilus (Super+E)
- [x] Terminal: Kitty (Super+Q) / Ghostty for rofi
- [x] Menu: Rofi (Super+R)

**Files:**
- `home/desktop/hyprland/settings.nix`

### S03: Keyboard Layouts — Deferred
Single EurKey layout sufficient for now.

**Files:**
- `home/desktop/hyprland/settings.nix`

### S04: Waybar Icons ✅
- [x] Install Nerd Font (JetBrainsMono Nerd Font)
- [x] Configure proper icons for workspace indicators
- [x] Add icons to all modules (clock, network, audio, battery, etc.)
- [x] Ensure icon font is loaded in Waybar config

**Files:**
- `home/desktop/shell/waybar/default.nix`
- `home/apps/packages.nix` (fonts)

## Verification

- [x] Rofi launches with Super+R and shows themed application list
- [x] File manager opens with Super+E
- [x] Terminal opens with Super+Q
- [x] All Waybar modules display proper Nerd Font icons
- [x] Icons render correctly (no missing glyph boxes)

## Dependencies

- M01: VM Hyprland Setup (complete)

## Notes

- Rofi theming should match overall desktop color scheme
- Consider using `xdg.mimeApps` for MIME associations in Home Manager
- Nerd Fonts package in nixpkgs: `nerdfonts` or specific font like `(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })`
- Hyprland keyboard layout: `input { kb_layout = us,tr; kb_options = grp:alt_shift_toggle; }`
