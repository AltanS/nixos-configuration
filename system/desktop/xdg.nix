# XDG portal configuration for Hyprland/Wayland
{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    wayland-utils
  ];
}
