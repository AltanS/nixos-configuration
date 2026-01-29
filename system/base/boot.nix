# Default boot configuration - can be overridden by hosts
{ lib, ... }: {
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}
