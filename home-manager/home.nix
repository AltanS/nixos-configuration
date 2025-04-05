{ homeStateVersion, user, ... }: {
  imports = [
    ./modules
  ];

  programs.kitty.enable = true;
  
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };

  services.ssh-agent.enable = true;
}