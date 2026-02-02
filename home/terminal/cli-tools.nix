{ pkgs, ... }: {
  # Zoxide - smart cd replacement
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];  # Replace cd with zoxide
  };

  # Eza - modern ls replacement
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  # Ripgrep for fast search
  home.packages = with pkgs; [
    ripgrep
    lazygit
    lazydocker
    btop
    fastfetch
    impala
    bluetui
    yazi
    duf
    procs
    bandwhich
  ];
}
