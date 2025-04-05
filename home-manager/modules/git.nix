{ config, pkgs, userSpecificData, ... }:
{
  programs.git = {
    enable = true;
    # Use userSpecificData directly
    userName = userSpecificData.gitUsername or null;
    userEmail = userSpecificData.gitEmail or null;

    # Optional: Set default editor (if different from system $EDITOR)
    # editor = "nvim";

    # Optional: Enable LFS support
    # lfs.enable = true;

    # Optional: Extra global Git configuration
    extraConfig = {
      init.defaultBranch = "main";
      # github.user = "your-github-username"; # Useful for some tools
      core.autocrlf = "input"; # Recommended for cross-platform compatibility
      pull.rebase = false; # Example preference
    };

    # Optional: Exclude global .gitignore patterns
    # ignores = [
    #   "*~"
    #   ".DS_Store"
    # ];
  };
} 