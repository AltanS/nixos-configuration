# GDM + GNOME for full desktop fallback (thinkcentre only)
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
