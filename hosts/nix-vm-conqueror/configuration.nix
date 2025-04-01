{ pkgs, stateVersion, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../modules
  ];

  environment.systemPackages = [ pkgs.home-manager ];

  networking.hostName = hostname;

  # Enable Spice agent for clipboard sharing
  services.spice-vdagentd.enable = true;

  system.stateVersion = stateVersion;
}