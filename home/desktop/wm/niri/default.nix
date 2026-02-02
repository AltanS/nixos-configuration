{ desktop, hostname, lib, ... }:
let
  # Shells that manage their own startup via systemd should not be spawned here
  shellCommand = {
    waybar = [ "waybar" ];
    noctalia = [ "noctalia" ];
    dms = null;
  }.${desktop.shell};

  # niri-unstable has overview feature but doesn't work in VMs
  # (see: https://github.com/Smithay/smithay/issues/1415)
  useUnstable = hostname != "vm";

  # Overview keybind only available in niri-unstable
  overviewBinds = lib.optionalAttrs useUnstable {
    "Mod+Tab".action.toggle-overview = {};
  };

  # Shell-specific keybindings
  noctaliaBinds = {
    # Noctalia launcher (Ctrl+R)
    "Ctrl+R".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
    # Control center (quick settings, notifications)
    "Mod+N".action.spawn = [ "noctalia-shell" "ipc" "call" "controlCenter" "toggle" ];
    # Settings panel
    "Mod+I".action.spawn = [ "noctalia-shell" "ipc" "call" "settings" "toggle" ];
    # Keybind cheatsheet
    "Mod+F1".action.spawn = [ "noctalia-shell" "ipc" "call" "plugin:keybind-cheatsheet" "toggle" ];
  };

  waybarBinds = {
    # Rofi app launcher (Ctrl+R)
    "Ctrl+R".action.spawn = [ "rofi" "-show" "drun" ];
    # SwayNC notification center
    "Mod+N".action.spawn = [ "swaync-client" "-t" ];
  };

  dmsBinds = {
    # DMS spotlight launcher
    "Ctrl+R".action.spawn = [ "dms" "ipc" "call" "spotlight" "toggle" ];
    # DMS notifications
    "Mod+N".action.spawn = [ "dms" "ipc" "call" "notifications" "toggle" ];
    # DMS settings
    "Mod+I".action.spawn = [ "dms" "ipc" "call" "settings" "toggle" ];
  };

  shellBinds = {
    noctalia = noctaliaBinds;
    waybar = waybarBinds;
    dms = dmsBinds;
  }.${desktop.shell};
in {
  # Note: niri-flake NixOS module already provides home-manager integration
  # Don't import homeModules.niri here to avoid conflicts

  programs.niri = {
    settings = {
      input.keyboard.xkb.layout = "eu";

      layout = {
        gaps = 10;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
      };

      spawn-at-startup = [
        # NOTE: swww-daemon and wallpaper-rotate removed - noctalia manages wallpapers
      ] ++ lib.optional (shellCommand != null) { command = shellCommand; };

      environment = {
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
      };

      # Allow client-side decorations so apps like Ghostty can show their header bars
      prefer-no-csd = false;

      window-rules = [
        {
          matches = [{ app-id = "^imv$"; } { app-id = "^mpv$"; }];
          open-floating = true;
        }
        {
          matches = [{ title = "Picture-in-Picture"; }];
          open-floating = true;
        }
      ];

      binds = {
        # Show hotkey overlay (Mod+? or Mod+Shift+/)
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};

        # Application launchers
        "Ctrl+Alt+T".action.spawn = "ghostty";
        "Mod+E".action.spawn = "nautilus";

        # Window management
        "Alt+Q".action.close-window = {};
        "Mod+Shift+E".action.quit = { skip-confirmation = true; };

        # Focus movement
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};

        # Window movement
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};
        "Mod+Shift+Down".action.move-window-down = {};
        "Mod+Shift+Up".action.move-window-up = {};
        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+L".action.move-column-right = {};
        "Mod+Shift+J".action.move-window-down = {};
        "Mod+Shift+K".action.move-window-up = {};

        # Workspace navigation (by number)
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        # Workspace navigation (sequential)
        "Mod+Page_Down".action.focus-workspace-down = {};
        "Mod+Page_Up".action.focus-workspace-up = {};
        "Mod+U".action.focus-workspace-down = {};
        "Mod+O".action.focus-workspace-up = {};

        # Move window to workspace (by number)
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Move window to workspace (sequential)
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+O".action.move-column-to-workspace-up = {};

        # Layout
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};
        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};

        # Floating
        "Mod+V".action.toggle-window-floating = {};
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

        # Resize
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        # Screenshot
        "Print".action.screenshot = {};
        "Mod+Print".action.screenshot-screen = {};
        "Mod+Shift+Print".action.screenshot-window = {};

        # Close window with Alt+F4
        "Alt+F4".action.close-window = {};
      } // shellBinds // overviewBinds;
    };
  };
}
