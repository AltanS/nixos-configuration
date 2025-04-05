{
  imports = [
    ./bat.nix
    ./hyprland
    ./swaync
    # ./wofi # Removed wofi
    ./rofi.nix # Added rofi
    ./kitty.nix
    ./waybar # Added waybar (assuming it exists based on list_dir)
  ];
}