{ lib, config, homeStateVersion, user, ... }: {
  imports = [
    ./desktop
    ./terminal
    ./apps
  ];

  # Unfree packages are allowed system-wide via nixpkgs.config.allowUnfree = true
  # in system/base/nix.nix. With useGlobalPkgs = true, home-manager inherits that
  # setting, so no nixpkgs.config is needed here.

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  xdg.enable = true;
  services.ssh-agent.enable = true;
}
