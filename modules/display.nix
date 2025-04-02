{ pkgs, ... }: {
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
  };

  # Basic OpenGL support
  hardware.opengl = {
    enable = true;
  };

  # Basic graphics utilities
  environment.systemPackages = with pkgs; [
    wayland-utils  # For Wayland debugging
  ];
} 