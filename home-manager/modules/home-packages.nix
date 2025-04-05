{ config, pkgs, ... }:
let 
  userData = config.specialArgs.userSpecificData; 
in
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
    fd
    fzf
    bat
    exa
    zoxide
    # Development tools
    gcc
    gnumake
    cmake
    # Text editors
    neovim
    # Terminal emulators
    alacritty
    # File managers
    ranger
    nnn
    # Media tools
    ffmpeg
    imagemagick
    # System tools
    lm_sensors
    pciutils
    usbutils
  ] ++ pkgs.lib.lists.optionals (userData ? "extraPackages") userData.extraPackages;
} 