{ lib, desktop, ... }:
let
  wmModule = {
    hyprland = ./wm/hyprland.nix;
    niri = ./wm/niri.nix;
  }.${desktop.wm};

  shellModules = {
    noctalia = [ ./shell/noctalia.nix ];
    waybar = [];
  };
in {
  imports = [
    wmModule
    ./shared/audio.nix
    ./shared/xdg.nix
    ./greetd.nix
  ] ++ (shellModules.${desktop.shell} or []);
}
