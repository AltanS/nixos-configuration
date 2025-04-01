{ pkgs, ... }: {
  # Enable Hyprland as a Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # For X11 app compatibility
  };

  # Configure a Wayland-compatible display manager
  # Note: SDDM has Wayland support but still needs some X server components
  services.displayManager = {
    # GDM has better native Wayland support than SDDM
    gdm = {
      enable = true;
      wayland = true;  # Explicitly enable Wayland support
    };
    # Configure auto-login for VM testing
    autoLogin = {
      enable = true;
      user = "altan";
    };
    # Default to Hyprland session
    defaultSession = "hyprland";
  };

  # Required hardware acceleration for Wayland
  hardware.opengl = {
    enable = true;
  };

  # Include essential Wayland utilities
  environment.systemPackages = with pkgs; [
    waybar        # Status bar
    kitty         # Terminal (Wayland native)
    wofi          # Application launcher for Wayland
    grim          # Screenshot tool for Wayland
    slurp         # Region selection for Wayland
    wl-clipboard  # Clipboard tool for Wayland
    xdg-desktop-portal-hyprland  # XDG portal for Hyprland
    xdg-utils     # For xdg-open and other utilities
  ];

  # Configure XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.hyprland.default = [ "hyprland" "gtk" ];
  };
}