{ pkgs, ... }: {
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    
    # Basic display manager configuration
    displayManager = {
      gdm.enable = true;
      # Default to Hyprland if available, fallback to a basic session if not
      defaultSession = "hyprland-uwsm";
    };
  };

  # Basic OpenGL support
  hardware.opengl = {
    enable = true;
  };

  # Basic graphics utilities
  environment.systemPackages = with pkgs; [
    wayland-utils  # For Wayland debugging
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
} 