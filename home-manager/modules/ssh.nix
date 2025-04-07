# Need lib, config for specialArgs and homeDirectory, pkgs potentially for paths
{ lib, config, pkgs, userSpecificData, ... }:
let
  # Function to expand ~ in paths within extraConfig
  expandHome = path: 
    if lib.strings.hasPrefix "~/" path then
      config.home.homeDirectory + builtins.substring 1 (lib.stringLength path) path
    else
      path;
  
  # Get identities from user data, default to empty list
  identities = userSpecificData.sshIdentities or [];

  # Create IdentityFile lines for extraConfig
  identityFileLines = lib.strings.concatMapStringsSep "\n" 
    (identityPath: "  IdentityFile ${expandHome identityPath}") 
    identities;
in
{
  # Configure the SSH client (generates ~/.ssh/config)
  programs.ssh = {
    enable = true;

    # Automatically add keys to the agent when first used.
    # Options: "no" (default), "yes", "confirm", "ask", time interval (e.g. "1h")
    addKeysToAgent = "confirm";

    # You can configure host-specific settings here using matchBlocks
    # matchBlocks = {
    #   "github.com" = {
    #     user = "git";
    #     # If you only wanted a key for a specific host:
    #     # identityFile = "~/.ssh/id_github"; 
    #   };
    #   "*.internal.example.com" = { 
    #      forwardAgent = true; 
    #   };
    # };

    # Add global settings not covered by specific options
    extraConfig = ''
# Global settings applied to all hosts unless overridden

# Specify identity files from userSpecificData
${identityFileLines}

# Other global settings can go here, e.g.:
# ForwardAgent no
# HashKnownHosts yes
    '';
  };

  # Note: The SSH agent service should still be enabled separately 
  # (e.g., in home.nix via services.ssh-agent.enable = true) 
  # for addKeysToAgent to work effectively.
} 