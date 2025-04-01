{ config, pkgs, ... }: {
  # Enable Hyprland configuration through Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    
    # Basic configuration for Hyprland
    settings = {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1"  # Use preferred mode for all monitors
      ];
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      
      # Decoration settings
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };
      
      # Input settings (mouse, touchpad, keyboard)
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
      };
      
      # Animation settings
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Window rules
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
      ];
      
      # Key bindings
      bind = [
        # Launch terminal
        "SUPER, Return, exec, kitty"
        # Close window
        "SUPER, Q, killactive,"
        # Launch app launcher
        "SUPER, D, exec, wofi --show drun"
        # Switch workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        # Move windows to workspaces
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        # Window navigation
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
      ];
    };
  };
  
  # Configure Waybar for Hyprland
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "clock" "tray"];
      };
    };
  };
} 