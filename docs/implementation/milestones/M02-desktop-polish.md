# M02: Desktop Polish

**Status:** Pending
**Priority:** Medium
**Created:** 2026-01-23

## Objective

Polish the Hyprland desktop experience with proper application launcher theming, default application configuration, keyboard layout support, and improved Waybar icons.

## Specs

### S01: Application Launcher (Rofi)
- [ ] Configure rofi as the application launcher
- [ ] Apply consistent theming (colors, fonts, borders)
- [ ] Set up drun mode for launching applications
- [ ] Configure window switcher mode
- [ ] Add keybinding in Hyprland (Super+D or similar)

**Files:**
- `home/desktop/rofi.nix`
- `home/desktop/hyprland/binds.nix`

### S02: Default Apps Configuration
- [ ] Set default web browser (Firefox/Chromium)
- [ ] Set default file manager (Nautilus/Thunar)
- [ ] Set default terminal emulator (Kitty)
- [ ] Set default text editor
- [ ] Set default image viewer
- [ ] Configure XDG MIME associations

**Files:**
- `home/apps/default-apps.nix` (new)
- `home/default.nix`

### S03: Keyboard Layouts
- [ ] Configure multiple keyboard layouts (e.g., US, TR)
- [ ] Set up layout switching keybinding (Super+Space or Alt+Shift)
- [ ] Add layout indicator to Waybar
- [ ] Ensure layouts persist across sessions

**Files:**
- `home/desktop/hyprland/settings.nix`
- `home/desktop/waybar.nix`

### S04: Waybar Icons
- [ ] Install Nerd Font (JetBrainsMono Nerd Font or similar)
- [ ] Configure proper icons for workspace indicators
- [ ] Add icons to all modules (clock, network, audio, battery, etc.)
- [ ] Ensure icon font is loaded in Waybar config

**Files:**
- `home/desktop/waybar.nix`
- `home/default.nix` (fonts)

## Verification

- [ ] Rofi launches with Super+D and shows themed application list
- [ ] Opening a URL from terminal launches configured browser
- [ ] Double-clicking files opens correct application
- [ ] Keyboard layout switches with configured keybinding
- [ ] Layout indicator shows current layout in Waybar
- [ ] All Waybar modules display proper Nerd Font icons
- [ ] Icons render correctly (no missing glyph boxes)

## Dependencies

- M01: VM Hyprland Setup (complete)

## Notes

- Rofi theming should match overall desktop color scheme
- Consider using `xdg.mimeApps` for MIME associations in Home Manager
- Nerd Fonts package in nixpkgs: `nerdfonts` or specific font like `(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })`
- Hyprland keyboard layout: `input { kb_layout = us,tr; kb_options = grp:alt_shift_toggle; }`
