{ inputs, pkgs, ... }: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    # Note: NOT importing dms.homeModules.niri -- it conflicts with niri-flake
    # by injecting include directives for DMS-generated files into config.kdl.
    # Our niri config is managed by programs.niri.settings via niri-flake instead.
    inputs.dms-plugin-registry.modules.default
  ];

  # DMS bundles its own quickshell build which lacks qtwayland in its closure.
  # Adding it here puts the Wayland platform plugin in QT_PLUGIN_PATH.
  home.packages = [ pkgs.kdePackages.qtwayland ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
  };
}
