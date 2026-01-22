{ pkgs, stateVersion, hostname, ... }: {
  imports = [
    ./hardware.nix
    ../../system/core
    ../../system/desktop
    ../../system/desktop/gnome.nix  # GDM + GNOME as fallback
    ../../system/hardware
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = stateVersion;
}
