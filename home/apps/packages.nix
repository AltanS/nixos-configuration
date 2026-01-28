{ pkgs, hostname, userSpecificData, ... }:
let
  # Minimal packages for all hosts (including VM)
  basePackages = with pkgs; [
    # Essential desktop apps
    firefox
    nautilus

    # Terminal emulators
    ghostty
    kitty

    # Fonts (JetBrains Mono with Nerd Font icons)
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # Icon themes
    papirus-icon-theme

    # CLI utilities
    cliphist
    wl-clipboard
    rofi
    wget
    curl
    git
    htop
    tree
    ripgrep
    fzf
    bat
    zoxide
    nano

    # Development
    nodejs
    python3

    # Wayland utilities
    libsForQt5.xwaylandvideobridge
    libnotify
  ];

  # Additional packages for physical hosts (not VM)
  extendedPackages = with pkgs; [
    # Productivity
    anki
    obsidian
    onlyoffice-desktopeditors
    xournalpp
    evince

    # Development
    vscode
    code-cursor
    zed-editor

    # Media & creativity
    spotify
    pinta
    mpv

    # Communication & sharing
    localsend

    # Browsers
    google-chrome

    # Utilities
    gearlever
  ];

  isPhysicalHost = hostname != "vm";
in {
  home.packages = basePackages
    ++ (if isPhysicalHost then extendedPackages else [])
    ++ (userSpecificData.extraPackages or []);
}
