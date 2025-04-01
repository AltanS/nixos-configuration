{ pkgs, stateVersion, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../modules
  ];

  # Direct boot configuration for VM
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  
  # Explicitly disable systemd-boot
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  # VM-specific graphics settings
  services.xserver.videoDrivers = [ "qxl" ];
  hardware.opengl.extraPackages = with pkgs; [ mesa.drivers ];
  
  # Wayland needs these for VM
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  environment.systemPackages = [ pkgs.home-manager ];

  networking.hostName = hostname;

  # Enable Spice agent for clipboard sharing
  services.spice-vdagentd.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # SSH settings
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
  };

  system.stateVersion = stateVersion;
}