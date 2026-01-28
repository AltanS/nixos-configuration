{ inputs, pkgs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # gpu-screen-recorder required by screen-recorder plugin
  home.packages = [ pkgs.gpu-screen-recorder ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      general = {
        colorScheme = "noctalia";
      };
      bar = {
        position = "top";
      };
      wallpaper = {
        enabled = true;
        directory = "/home/altan/.local/share/wallpapers";
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        setWallpaperOnAllMonitors = true;
      };
    };

    # Plugin sources and enabled plugins
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        timer = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        keybind-cheatsheet = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };

    # Plugin-specific settings
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;  # Only show when mic/cam/screen is active
      };
      timer = {
        compactMode = true;  # Compact bar display
      };
      screen-recorder = {
        frameRate = "60";
        videoCodec = "h264";
        quality = "very_high";
        showCursor = true;
      };
      keybind-cheatsheet = {
        columns = 3;
        mainMod = "Mod";  # niri uses Mod (Super)
      };
    };
  };
}
