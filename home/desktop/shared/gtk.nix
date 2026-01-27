{ pkgs, ... }: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # Optional: GTK theme (Gruvbox-inspired to match waybar)
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # QT theming to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
