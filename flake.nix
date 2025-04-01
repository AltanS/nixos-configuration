{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
  system = "x86_64-linux";
  homeStateVersion = "24.11";
  user = "altan";
  hosts = [
    { hostname = "nixos-vm-conqueror"; stateVersion = "24.11"; }
  ];

  makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
    system = system;
    specialArgs = {
      inherit inputs stateVersion hostname user homeStateVersion;
    };

    modules = [
      ./hosts/${hostname}/configuration.nix
      
      # Include home-manager as a NixOS module
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs homeStateVersion user;
        };
        home-manager.users.${user} = import ./home-manager/home.nix;
      }
    ];
  };

  in {
    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion;
        };
      }) {} hosts;
  };
}