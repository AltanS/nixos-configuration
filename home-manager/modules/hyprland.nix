{ config, pkgs, ... }: {
  # Enable Hyprland configuration through Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
} 