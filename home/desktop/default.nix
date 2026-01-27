{ lib, desktop, ... }:
let
  wmModule = {
    hyprland = ./wm/hyprland;
    niri = ./wm/niri;
  }.${desktop.wm};

  shellModule = {
    waybar = ./shell/waybar;
    noctalia = ./shell/noctalia;
  }.${desktop.shell};

  # Shell-specific shared components
  # - waybar needs rofi (launcher) and swaync (notifications)
  # - noctalia has these built-in
  waybarSharedModules = [
    ./shared/rofi.nix
    ./shared/swaync.nix
  ];
in {
  imports = [
    wmModule
    shellModule
    ./shared/wallpaper.nix
    ./shared/gtk.nix
  ] ++ lib.optionals (desktop.shell == "waybar") waybarSharedModules;
}
