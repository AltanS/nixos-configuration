{ config, pkgs, userSpecificData, ... }:
{
  # Enable the SSH agent service
  programs.ssh = {
    enable = true;
    # Automatically start the agent when the user logs in
    startAgent = true; 

    # Optional: Specify default identities to add automatically on startup
    # Assumes these private keys exist in ~/.ssh/
    # Do NOT put the key content here, just the paths.
    identities = pkgs.lib.lists.optionals (userSpecificData ? "sshIdentities") userSpecificData.sshIdentities;

    # Optional: Add common hosts for convenience
    # addKeysToAgent = "yes"; # Add keys to agent when needed
    # forwardAgent = true; # Enable agent forwarding for specific hosts if needed
    # matchBlocks = {
    #   "github.com" = {
    #     user = "git";
    #     identityFile = "~/.ssh/id_ed25519_github"; # Example specific key
    #   };
    #   "gitlab.com" = {
    #      user = "git";
    #      identityFile = "~/.ssh/id_ed25519_gitlab"; # Example specific key
    #   };
    # };
  };

  # Ensure necessary packages are available if needed by ssh-agent interactions
  # (usually not required as programs.ssh handles dependencies)
  # home.packages = with pkgs; [ gnupg pinentry ]; 
} 