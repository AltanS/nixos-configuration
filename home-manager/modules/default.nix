{
  imports = [
    # Core HM config modules
    ./git.nix
    ./ssh.nix
    ./home-packages.nix
    
    # User interface / WM modules
    ./hyprland
    ./waybar
    ./kitty.nix
    ./rofi.nix
    ./swaync
    # ./wofi # Assuming wofi is not used, keep commented or remove if definite

    # Other utility modules
    ./bat.nix

  ];
}