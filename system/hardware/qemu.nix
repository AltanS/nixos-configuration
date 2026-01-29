# QEMU/KVM VM hardware configuration
{ pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # VirtIO graphics for Hyprland (3D accelerated)
  services.xserver.videoDrivers = [ "virtio" ];

  # Graphics packages
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa ];
  };

  # VM-specific environment
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";  # Required for VMs
  };

  # Spice agent for clipboard sharing
  services.spice-vdagentd.enable = true;

  # SSH for debugging
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # VM-specific packages
  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
  ];
}
