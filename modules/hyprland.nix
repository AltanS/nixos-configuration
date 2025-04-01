{ pkgs, ... }: {
  # Enable Hyprland as a window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable XServer and display manager
  services.xserver = {
    enable = true;
    
    # Enable SDDM display manager
    displayManager = {
      sddm.enable = true;
      # Set Hyprland as the default session
      defaultSession = "hyprland";
      # Auto-login for VMs to make testing easier
      autoLogin = {
        enable = true;
        user = "altan";
      };
    };
  };

  # Enable required hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Include common graphical packages
  environment.systemPackages = with pkgs; [
    waybar        # Status bar
    kitty         # Terminal
    wofi          # Application launcher
    grim          # Screenshot tool
    slurp         # Region selection
    wl-clipboard  # Clipboard tool
  ];
}