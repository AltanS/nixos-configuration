{ pkgs, ... }: {
  # Rofi is used as app launcher with waybar shell
  home.packages = [ pkgs.rofi ];

  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0px;
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 16px;
        min-height: 0;
        color: #ebdbb2;
      }

      window#waybar {
        background: #1d2021;
      }

      #workspaces button label {
        color: #ebdbb2;
        padding: 0 10px;
      }
      #workspaces button.active label {
        color: #1d2021;
      }
      #workspaces button.active {
        background: #d65d0e;
      }

      #clock, #battery, #pulseaudio, #tray, #language, #weather {
        padding: 0 10px;
        margin: 0 10px;
      }

      #language {
        margin: 0;
        color: #d79921;
        border-bottom: 5px solid #d79921;
      }

      #custom-weather {
        margin: 0;
        color: #98971a;
        border-bottom: 5px solid #98971a;
      }

      #pulseaudio {
        margin: 0;
        color: #689d6a;
        border-bottom: 5px solid #689d6a;
      }

      #pulseaudio.muted {
        padding: 0 20px;
        color: #cc241d;
        border-bottom: 5px solid #cc241d;
      }

      #battery {
        margin: 0;
        color: #458588;
        border-bottom: 5px solid #458588;
      }

      #clock {
        margin: 0;
        color: #b16286;
        border-bottom: 5px solid #b16286;
      }

      #tray {
        margin: 0;
        color: #d65d0e;
        border-bottom: 5px solid #d65d0e;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "battery" "clock" "tray"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          format = "{name}";
          persistent-workspaces = { "*" = 5; };
        };

        "hyprland/language" = {
          format-en = "US";
          min-length = 5;
          tooltip = false;
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/Tashkent?format=%c%t'";
          interval = 300;
          class = "weather";
        };

        "pulseaudio" = {
          format = "VOL {volume}%";
          format-bluetooth = "BT {volume}%";
          format-muted = "MUTE";
          on-click = "pavucontrol";
        };

        "battery" = {
          states = { warning = 30; critical = 1; };
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
          format-alt = "{time}";
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
  };
}
