{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  security.pam.services.hyprlock = {};

  # Hyprland-specific portal for screensharing and other functionality
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
