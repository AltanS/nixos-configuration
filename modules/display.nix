{ pkgs, ... }: {
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Basic OpenGL support
  hardware.graphics = {
    enable = true;
  };

  # XDG Desktop Portal configuration for Hyprland/Wayland
  xdg.portal = {
    enable = true;
    # wlr is needed for screencasting
    # extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    # Or if using Hyprland directly:
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    # Enable GTK portal integration if needed
    # gtkUsePortal = true;
  };

  # Basic graphics utilities
  environment.systemPackages = with pkgs; [
    wayland-utils  # For Wayland debugging
  ];
} 