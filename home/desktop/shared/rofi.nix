{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      icon-theme = "Papirus";
      show-icons = true;
      terminal = "ghostty";
    };
  };
}
