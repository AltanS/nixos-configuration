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

  # VM-specific display configuration
  services.xserver.videoDrivers = [ "qxl" "virtio" ];  # VM-specific drivers

  # VM-specific environment variables for Wayland/Hyprland
  environment.sessionVariables = {
    # Required for Hyprland in VMs
    WLR_NO_HARDWARE_CURSORS = "1";  # Fixes cursor issues in VMs
    WLR_RENDERER_ALLOW_SOFTWARE = "1";  # Allows software rendering
    LIBGL_ALWAYS_SOFTWARE = "1";  # Force software rendering
    __GL_THREADED_OPTIMIZATIONS = "1";  # For better performance
  };

  # VM-specific packages
  environment.systemPackages = with pkgs; [ 
    home-manager
    vulkan-tools  # For checking Vulkan status
    mesa-demos    # For testing 3D acceleration
  ];

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