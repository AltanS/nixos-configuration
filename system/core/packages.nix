{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    htop
    wget
    curl
    git
    fzf
    ripgrep
    unzip
    zip
  ];
}
