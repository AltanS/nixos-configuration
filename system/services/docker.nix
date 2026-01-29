# Docker container runtime with compose support
{ config, pkgs, user, ... }: {
  virtualisation.docker = {
    enable = true;

    # Enable Docker Compose plugin (use as: docker compose)
    # This is the modern approach - compose is a Docker plugin
    enableOnBoot = true;

    # Use overlay2 storage driver (default, works well on most systems)
    # storageDriver = "overlay2";
  };

  # Add user to docker group for non-root access
  users.users.${user}.extraGroups = [ "docker" ];

  # Install docker-compose standalone (optional, for `docker-compose` command)
  # The plugin above provides `docker compose` (with space)
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
