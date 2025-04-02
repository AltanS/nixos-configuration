{ pkgs, ... }: {
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  # Basic OpenGL support
  hardware.graphics = {
    enable = true;
  };

  # Basic graphics utilities
  environment.systemPackages = with pkgs; [
    wayland-utils  # For Wayland debugging
  ];
} 