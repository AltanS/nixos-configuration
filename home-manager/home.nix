{ lib, config, homeStateVersion, user, ... }: {
  imports = [
    ./modules
  ];

  # Allow specific unfree packages by predicate
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkg.pname or "") [
    "obsidian"
    "vscode"
    "cursor"
    # Add other unfree package names here if needed
    # e.g., "slack" "zoom"
  ];

  # Basic user settings
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  # Ensure basic services/integrations are enabled
  xdg.enable = true;  # Sets up XDG base directories and environment variables

  # Enable user services
  services.ssh-agent = {
    enable = true;
  };

}