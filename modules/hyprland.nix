{ pkgs, ... }: {
  # Enable Hyprland as a Wayland compositor
  programs.hyprland = {
    enable = true;
    withUWSM  = true;
  };
}