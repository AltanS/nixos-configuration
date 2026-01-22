{ lib, config, userSpecificData, ... }:
let
  expandHome = path:
    if lib.strings.hasPrefix "~/" path then
      config.home.homeDirectory + builtins.substring 1 (lib.stringLength path) path
    else
      path;

  identities = userSpecificData.sshIdentities or [];

  identityFileLines = lib.strings.concatMapStringsSep "\n"
    (identityPath: "  IdentityFile ${expandHome identityPath}")
    identities;
in {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";

    extraConfig = ''
      ${identityFileLines}
    '';
  };
}
