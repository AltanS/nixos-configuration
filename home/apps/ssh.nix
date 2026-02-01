{ lib, config, userSpecificData, ... }:
let
  expandHome = path:
    if lib.strings.hasPrefix "~/" path then
      config.home.homeDirectory + builtins.substring 1 (lib.stringLength path) path
    else
      path;

  identities = userSpecificData.sshIdentities or [];
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
      addKeysToAgent = "confirm";
      identityFile = lib.optionals (identities != []) (map expandHome identities);
    };
  };
}
