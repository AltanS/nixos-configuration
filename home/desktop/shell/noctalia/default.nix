{ inputs, pkgs-unstable, ... }: {
  imports = [ inputs.noctalia.homeModules.default ];

  # quickshell provides the `qs` command needed for IPC
  home.packages = [
    pkgs-unstable.quickshell
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      general = {
        colorScheme = "noctalia";
      };
      bar = {
        position = "top";
      };
    };
  };
}
