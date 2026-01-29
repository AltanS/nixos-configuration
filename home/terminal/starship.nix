{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # Minimal, clean prompt
      format = ''
        $directory$git_branch$git_status$nix_shell$cmd_duration
        $character
      '';

      # Don't add blank line between prompts
      add_newline = false;

      # Directory - show 3 levels, truncate to repo root
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # Git branch
      git_branch = {
        format = "[$branch]($style) ";
        style = "bold purple";
      };

      # Git status - compact
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      # Nix shell indicator (important for nix-direnv)
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = "❄️ ";
        style = "bold blue";
        impure_msg = "";
        pure_msg = "pure";
      };

      # Command duration - only show if > 2s
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };

      # Prompt character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Disable modules we don't need
      aws.disabled = true;
      gcloud.disabled = true;
      azure.disabled = true;
      kubernetes.disabled = true;
      docker_context.disabled = true;
      package.disabled = true;
    };
  };
}
