{ pkgs, stateVersion, hostname, ... }: {
  imports = [
    ./hardware.nix
    ../../system/profiles/desktop.nix
    ../../system/desktop/gnome.nix  # GDM + GNOME as fallback
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/intel.nix
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  system.stateVersion = stateVersion;
}
