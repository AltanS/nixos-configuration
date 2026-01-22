{
  description = "NixOS configuration with Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    homeStateVersion = "24.11";

    # User definitions
    users = {
      altan = { dataPath = ./users/altan.nix; };
    };

    # Host definitions
    hosts = [
      { hostname = "vm"; stateVersion = "24.11"; }
      { hostname = "thinkcentre"; stateVersion = "24.11"; }
    ];

    # Helper to create NixOS system configuration
    makeSystem = { hostname, stateVersion }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs stateVersion hostname;
          user = "altan";
        };
        modules = [
          ./hosts/${hostname}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs homeStateVersion;
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
          inherit (host) hostname stateVersion;
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
