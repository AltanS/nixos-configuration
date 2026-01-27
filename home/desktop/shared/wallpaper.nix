{ pkgs, ... }:
let
  wallpaperDir = ../../../assets/wallpapers;

  # Time-based wallpaper schedule (similar to original XML):
  # Morning (6am-4pm): a_quiet_mind - calm morning scene
  # Evening (4pm-2am): million_little_pieces - vibrant evening
  # Night (2am-6am): you - quiet night
  wallpaperScript = pkgs.writeShellScriptBin "wallpaper-rotate" ''
    WALLPAPER_DIR="$HOME/.local/share/wallpapers"

    # Get current hour (0-23)
    HOUR=$(date +%H)
    HOUR=$((10#$HOUR))  # Remove leading zero for arithmetic

    if [ $HOUR -ge 6 ] && [ $HOUR -lt 16 ]; then
      # Morning/Day: 6am - 4pm
      WALLPAPER="$WALLPAPER_DIR/a_quiet_mind_by_aenami_dbjhb9n.png"
    elif [ $HOUR -ge 16 ] || [ $HOUR -lt 2 ]; then
      # Evening: 4pm - 2am
      WALLPAPER="$WALLPAPER_DIR/million_little_pieces_by_aenami_dapld5d.png"
    else
      # Night: 2am - 6am
      WALLPAPER="$WALLPAPER_DIR/you_by_aenami_dbe4nc2.png"
    fi

    # Wait for swww-daemon if not ready
    for i in $(seq 1 10); do
      ${pkgs.swww}/bin/swww query && break
      sleep 1
    done

    # Set wallpaper with smooth transition
    ${pkgs.swww}/bin/swww img "$WALLPAPER" \
      --transition-type grow \
      --transition-pos "0.9,0.1" \
      --transition-duration 2
  '';
in
{
  home.packages = [ pkgs.swww wallpaperScript ];

  # Link wallpapers to home directory
  home.file.".local/share/wallpapers" = {
    source = wallpaperDir;
    recursive = true;
  };

  # Systemd service for wallpaper rotation
  systemd.user.services.wallpaper-rotate = {
    Unit = {
      Description = "Rotate wallpaper based on time of day";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${wallpaperScript}/bin/wallpaper-rotate";
    };
  };

  # Timer to check wallpaper every hour
  systemd.user.timers.wallpaper-rotate = {
    Unit = {
      Description = "Wallpaper rotation timer";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
