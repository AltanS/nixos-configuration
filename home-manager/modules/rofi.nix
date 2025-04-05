# home-manager/modules/rofi.nix
{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    # You can add more configuration here later
    # For example, themes, plugins, etc.
    # theme = "solarized"; 
    extraConfig = {
       modi = "drun,run,window"; # Common modes
       icon-theme = "Papirus"; # Example icon theme (ensure it's installed if needed)
       show-icons = true;
       terminal = "kitty"; 
    };
  };
}
