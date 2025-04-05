{ config, pkgs, userSpecificData, ... }:
{
  # Allow unfree packages within Home Manager scope if needed
  # nixpkgs.config.allowUnfree = true; # Already set globally in modules/nix.nix

  # Define base packages for the user environment
  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    anki
    # code-cursor # Assuming vscode replaced this? Add back if needed.
    obsidian
    vscode # Keeping vscode as it was in both versions
    code-cursor

    # CLI utils
    ghostty
    cliphist
    kitty
    wl-clipboard
    rofi

    # Coding stuff
    nodejs # Keeping nodejs
    python3 # Using the default python3 alias, adjust if python311 is specifically needed

    # WM stuff - these seem specific to a graphical session managed by HM
    libsForQt5.xwaylandvideobridge
    libnotify
    # xdg-desktop-portal-gtk # Often managed by NixOS services
    # xdg-desktop-portal-hyprland # Often managed by NixOS services

    # Core utilities
    wget
    curl
    git
    htop
    tree
    ripgrep
    fzf
    bat
    zoxide
    # Text editors
    nano
  ] ++ pkgs.lib.lists.optionals (userSpecificData ? "extraPackages") userSpecificData.extraPackages;
} 