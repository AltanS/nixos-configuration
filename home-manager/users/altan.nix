{ pkgs, ... }: {
  # User-specific settings
  gitUsername = "Altan Sarisin";
  gitEmail = "altan.sarisin@gmail.com";
  sshIdentities = [ "~/.ssh/a.sarisin" ];

  # Optional: User-specific packages beyond the base home-packages
  extraPackages = with pkgs; [ 
    # Example: only altan needs 'gimp'
    # gimp 
  ]; 
} 