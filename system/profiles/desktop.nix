# Desktop profile: base system + desktop environment
# Use this for any host with a graphical desktop
{ ... }: {
  imports = [
    ../base
    ../desktop
  ];
}
