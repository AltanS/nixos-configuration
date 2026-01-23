{ pkgs, userSpecificData, ... }: {
  home.packages = with pkgs; [
    # Desktop apps
    anki
    obsidian
    vscode
    code-cursor

    # Terminal emulators
    ghostty
    kitty

    # Fonts
    nerd-fonts-jetbrains-mono

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
  ] ++ (userSpecificData.extraPackages or []);
}
