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
in {
  imports = [
    wmModule
    shellModule
    ./shared/rofi.nix
    ./shared/swaync.nix
    ./shared/wallpaper.nix
    ./shared/gtk.nix
  ];
}
