{ homeStateVersion, user, ... }: {
  imports = [
    ./modules
  ];

  # Allow specific unfree packages by predicate
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkg.pname or "") [
    "obsidian"
    "vscode"
    "code-cursor"
    # Add other unfree package names here if needed
    # e.g., "slack" "zoom"
  ];

  programs.kitty.enable = true;
  
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  services.ssh-agent.enable = true;
}