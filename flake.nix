{
  description = "NixOS configuration with modular WM/shell support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, niri-flake, noctalia, ... }@inputs:
  let
    system = "x86_64-linux";
    homeStateVersion = "24.11";

    # User definitions
    users = {
      altan = { dataPath = ./users/altan.nix; };
    };

    # Host definitions with desktop configuration
    hosts = [
      {
        hostname = "vm";
        stateVersion = "24.11";
        desktop = { wm = "niri"; shell = "noctalia"; };
      }
      {
        hostname = "thinkcentre";
        stateVersion = "24.11";
        desktop = { wm = "hyprland"; shell = "waybar"; };
      }
    ];

    # Helper to create NixOS system configuration
    makeSystem = { hostname, stateVersion, desktop }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs stateVersion hostname desktop;
          user = "altan";
        };
        modules = [
          ./hosts/${hostname}
          home-manager.nixosModules.home-manager
          niri-flake.nixosModules.niri
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs homeStateVersion desktop;
                user = "altan";
                userSpecificData = import ./users/altan.nix { pkgs = nixpkgs.legacyPackages.${system}; };
              };
              users.altan = import ./home;
            };
          }
        ];
      };

  in {
    # NixOS configurations for each host
    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion desktop;
        };
      }
    ) {} hosts;

    # Standalone home-manager configurations (for non-NixOS systems)
    homeConfigurations = nixpkgs.lib.mapAttrs' (username: userData: {
      name = username;
      value = let
        pkgs = nixpkgs.legacyPackages.${system};
        userSpecificData = import userData.dataPath { inherit pkgs; };
      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs homeStateVersion;
          user = username;
          inherit userSpecificData;
        };
        modules = [ ./home ];
      };
    }) users;

    # VM build target for quick testing
    packages.${system}.vm = self.nixosConfigurations.vm.config.system.build.vm;
  };
}
