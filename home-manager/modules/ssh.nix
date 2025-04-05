{ config, pkgs, userSpecificData, ... }:
{
  # Enable the SSH agent service
  programs.ssh = {
    enable = true;
    # Automatically start the agent when the user logs in
    # This will typically load default keys like id_rsa, id_ed25519 from ~/.ssh
    startAgent = true; 

    # Optional: Add common hosts for convenience using matchBlocks
    # This IS the correct way to specify per-host keys if needed.
    # You could potentially make this dynamic using userSpecificData if required.
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