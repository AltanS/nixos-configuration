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
}