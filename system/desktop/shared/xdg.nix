# XDG portal configuration for Wayland
# WM-specific portals are configured in each WM module
{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    # gtk portal provides file chooser dialogs and other common functionality
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    wayland-utils
  ];
}
