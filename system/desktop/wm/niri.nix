{ pkgs, inputs, lib, hostname, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  # niri-unstable has the overview feature (Mod+Tab) but doesn't work in VMs
  # due to virtual GPU compatibility issues (see: https://github.com/Smithay/smithay/issues/1415)
  # Use stable for VM, unstable for real hardware
  useUnstable = hostname != "vm";

  niriPackage = if useUnstable
    then inputs.niri-flake.packages.${system}.niri-unstable
    else pkgs.niri;
in {
  # Enable niri via the niri-flake NixOS module
  programs.niri.enable = true;

  programs.niri.package = niriPackage;

  # xdg-desktop-portal-gnome works well with niri
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
}
