{ config, pkgs, ... }: {
  # Enable Hyprland configuration through Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
} 