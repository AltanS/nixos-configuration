{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Add packages here that you want on ALL systems
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