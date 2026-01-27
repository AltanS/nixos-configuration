{ pkgs, ... }: {
  # GitHub CLI
  programs.gh = {
    enable = true;
  };

  # Direnv for per-directory environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;  # Better nix integration
  };

  # jq for JSON processing
  home.packages = [ pkgs.jq ];
}
