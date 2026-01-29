---
name: add-system-service
description: This skill should be used when the user asks to "add a service", "install docker", "enable a system service", "add podman", "enable virtualization", or wants to add any system-level service to NixOS. Provides patterns for creating service modules and integrating them with hosts.
---

# Adding System Services to NixOS

This skill covers adding system-level services (Docker, databases, etc.) to the NixOS configuration.

## Service Module Location

```
system/services/<service-name>.nix
```

## Standard Service Pattern

```nix
# system/services/<service-name>.nix
{ config, pkgs, user, ... }: {
  # Enable the service
  services.<service-name>.enable = true;

  # Add user to service group if needed
  users.users.${user}.extraGroups = [ "<service-group>" ];

  # Install related tools
  environment.systemPackages = with pkgs; [
    <related-package>
  ];
}
```

## Docker Example

```nix
# system/services/docker.nix
{ pkgs, user, ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  users.users.${user}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}
```

## PostgreSQL Example

```nix
# system/services/postgresql.nix
{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
    '';
  };
}
```

## Integration Steps

1. **Create the service module** in `system/services/`

2. **Import in host config**:
```nix
# hosts/<hostname>/default.nix
imports = [
  ./hardware.nix
  ../../system/profiles/desktop.nix
  ../../system/services/<service-name>.nix  # Add this
];
```

3. **Rebuild and switch**:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

4. **For VM development**, use dev-sync:
```bash
./scripts/dev-sync rebuild
```

## Common Services

| Service | NixOS Option | Group |
|---------|--------------|-------|
| Docker | `virtualisation.docker` | `docker` |
| Podman | `virtualisation.podman` | - |
| PostgreSQL | `services.postgresql` | - |
| MySQL | `services.mysql` | - |
| Redis | `services.redis` | - |
| nginx | `services.nginx` | - |

## Verification

After rebuild, verify service is running:

```bash
systemctl status <service-name>

# For Docker
docker run hello-world
```

## Important Notes

- The `user` variable comes from flake.nix extraSpecialArgs
- Services in `system/services/` are opt-in per host
- Don't add services directly to `system/base/` (those apply to all hosts)
