{ pkgs, inputs, ... }: {
  # Enable niri via the niri-flake NixOS module
  programs.niri.enable = true;

  # Enable xwayland for compatibility with X11 apps
  programs.niri.package = pkgs.niri;

  # xdg-desktop-portal-gnome works well with niri
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Enable polkit for authentication dialogs
  security.polkit.enable = true;
}
