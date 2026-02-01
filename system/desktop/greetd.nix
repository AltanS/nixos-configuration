# Minimal display manager for Wayland
{ pkgs, user, desktop, ... }:
let
  wmCommand = {
    hyprland = "Hyprland";
    niri = "niri-session";
  }.${desktop.wm};
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${wmCommand}";
        user = "greeter";
      };
      initial_session = {
        command = wmCommand;
        user = user;
      };
    };
  };

  # greetd runs on tty1
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
