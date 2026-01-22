{ lib, config, homeStateVersion, user, ... }: {
  imports = [
    ./desktop
    ./terminal
    ./apps
  ];

  # Allow specific unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkg.pname or "") [
    "obsidian"
    "vscode"
    "cursor"
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  xdg.enable = true;
  services.ssh-agent.enable = true;
}
