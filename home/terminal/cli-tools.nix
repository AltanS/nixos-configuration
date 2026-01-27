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
  home.packages = [ pkgs.ripgrep ];
}
