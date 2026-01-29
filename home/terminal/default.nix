{
  imports = [
    ./kitty.nix
    ./ghostty.nix
    ./bat.nix
    ./starship.nix
    ./atuin.nix
    ./cli-tools.nix
    ./dev-tools.nix
  ];

  # Enable bash so home-manager manages .bashrc and integrations work
  programs.bash.enable = true;

  # Shell aliases
  home.shellAliases = {
    cat = "bat";
  };
}
