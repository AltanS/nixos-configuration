{
  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages system-wide
  nixpkgs.config = {
    # Basic setting to allow unfree packages
    allowUnfree = true;
  };
}