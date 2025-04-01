{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    anki
    code-cursor
    obsidian

    # CLI utils
    fzf
    htop
    ripgrep
    unzip
    w3m
    wget
    wl-clipboard
    zip

    # Coding stuff
    nodejs
    python311
  ];
}