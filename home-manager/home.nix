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
  dbus.enable = true; # Ensures user D-Bus session integration
  xdg.enable = true;  # Sets up XDG base directories and environment variables

  # Enable user services
  services.ssh-agent = {
    enable = true;
    # Load specific identities defined in userSpecificData
    identities = lib.lists.optionals (config.specialArgs.userSpecificData ? "sshIdentities") 
                                     config.specialArgs.userSpecificData.sshIdentities;
  };

  # Enable programs configured via modules (like kitty, rofi, etc.)
  # programs.kitty.enable = true; # This might be set within modules/kitty.nix already
}