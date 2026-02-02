{ pkgs, ... }: {
  # Install ghostty
  home.packages = [ pkgs.ghostty ];

  # Ghostty configuration
  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 12

    # Window padding
    window-padding-x = 8
    window-padding-y = 4

    # Header/tabs
    gtk-titlebar = true
    gtk-tabs-location = top
    gtk-wide-tabs = false
    gtk-single-instance = true

    # Theme - dark
    theme = Catppuccin Mocha
    background-opacity = 0.95

    # Cursor
    cursor-style = block
    cursor-style-blink = false

    # Shell integration with title updates
    shell-integration = detect
    shell-integration-features = cursor,sudo,title

    # Show working directory in window subtitle (GTK/Linux feature)
    window-subtitle = working-directory

    # Scrollback
    scrollback-limit = 10000

    # Clipboard
    clipboard-read = allow
    clipboard-write = allow
    clipboard-paste-protection = false


    # Mouse
    mouse-hide-while-typing = true

    # Quick terminal (drop-down)
    keybind = global:ctrl+grave_accent=toggle_quick_terminal
  '';
}
