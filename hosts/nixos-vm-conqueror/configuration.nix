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

  # VM-specific Wayland settings
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ mesa.drivers ];
  };
  
  # Essential environment variables for Wayland in a VM
  environment.sessionVariables = {
    # Essential for Wayland compositors in VMs
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    # For better scaling
    GDK_SCALE = "1";
    # Enable fractional scaling
    GDK_DPI_SCALE = "1";
  };

  # Minimal X11 support for GUI applications that might need it
  services.xserver.enable = true;
  
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