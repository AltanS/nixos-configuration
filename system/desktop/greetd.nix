# Minimal display manager for Wayland
{ pkgs, user, desktop, ... }:
let
  # Custom niri-session wrapper that fixes the deprecated import-environment warning
  # The upstream niri-session calls `systemctl --user import-environment` without
  # explicit variable names, which is deprecated in newer systemd versions.
  niri-session-fixed = pkgs.writeShellScriptBin "niri-session-fixed" ''
    if [ -n "$SHELL" ] &&
       grep -q "$SHELL" /etc/shells &&
       ! (echo "$SHELL" | grep -q "false") &&
       ! (echo "$SHELL" | grep -q "nologin"); then
      if [ "$1" != '-l' ]; then
        exec bash -c "exec -l '$SHELL' -c '$0 -l $*'"
      else
        shift
      fi
    fi

    # Try to detect the service manager that is being used
    if hash systemctl >/dev/null 2>&1; then
        # Make sure there's no already running session.
        if systemctl --user -q is-active niri.service; then
          echo 'A niri session is already running.'
          exit 1
        fi

        # Reset failed state of all user units.
        systemctl --user reset-failed

        # Import the login manager environment with explicit variable names
        # (fixes "calling import-environment without a list of variable names is deprecated")
        systemctl --user import-environment \
          DBUS_SESSION_BUS_ADDRESS \
          DISPLAY \
          HOME \
          LANG \
          LOGNAME \
          NIX_PATH \
          NIX_PROFILES \
          PATH \
          SHELL \
          USER \
          WAYLAND_DISPLAY \
          XDG_CONFIG_DIRS \
          XDG_CURRENT_DESKTOP \
          XDG_DATA_DIRS \
          XDG_RUNTIME_DIR \
          XDG_SESSION_CLASS \
          XDG_SESSION_ID \
          XDG_SESSION_TYPE \
          XDG_SESSION_DESKTOP \
          NIXOS_OZONE_WL \
          QT_QPA_PLATFORM \
          GTK_PATH \
          GIO_EXTRA_MODULES \
          XCURSOR_PATH \
          NIX_XDG_DESKTOP_PORTAL_DIR

        # DBus activation environment is independent from systemd. While most of
        # dbus-activated services are already using `SystemdService` directive, some
        # still don't and thus we should set the dbus environment with a separate
        # command.
        if hash dbus-update-activation-environment 2>/dev/null; then
            dbus-update-activation-environment --all
        fi

        # Start niri and wait for it to terminate.
        systemctl --user --wait start niri.service

        # Force stop of graphical-session.target.
        systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target

        # Unset environment that we've set.
        systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
    else
        echo "No systemd detected, please use niri --session instead."
    fi
  '';

  wmCommand = {
    hyprland = "Hyprland";
    niri = "${niri-session-fixed}/bin/niri-session-fixed";
  }.${desktop.wm};
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${wmCommand}";
        user = "greeter";
      };
      initial_session = {
        command = wmCommand;
        user = user;
      };
    };
  };

  # greetd runs on tty1
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
