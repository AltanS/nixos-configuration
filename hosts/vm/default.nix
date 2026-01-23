{ pkgs, stateVersion, hostname, user, ... }: {
  imports = [
    ./hardware.nix
    ../../system/core
    ../../system/desktop
    ../../system/hardware/vm.nix
    ../../system/desktop/greetd.nix
  ];

  # VM uses GRUB, not systemd-boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  # Development convenience - VM only!
  users.users.${user}.initialPassword = "test";
  security.sudo.wheelNeedsPassword = false;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = stateVersion;
}
