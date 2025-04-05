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
    # Define users and their data paths
    users = {
      altan = { dataPath = ./home-manager/users/altan.nix; };
      # bob = { dataPath = ./home-manager/users/bob.nix; }; # Add future users here
    };
    hosts = [
      { hostname = "nixos-vm-conqueror"; stateVersion = "24.11"; }
      { hostname = "thinkcentre"; stateVersion = "24.11"; }
    ];

    makeSystem = { hostname, stateVersion }: nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs stateVersion hostname;
        user = "altan"; # Still hardcoded for now - could be derived from host if needed
      };

      modules = [
        ./hosts/${hostname}/configuration.nix
        ./modules/default-packages.nix
      ];
    };

  in {
    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion;
        };
      }) {} hosts;

    # Build home configurations for all defined users
    homeConfigurations = nixpkgs.lib.mapAttrs' (username: userData: {
      name = username;
      value = let
        # Define pkgs for the current user configuration
        currentPkgs = nixpkgs.legacyPackages.${system};
        # Import the user data, passing the defined pkgs
        currentUserSpecificData = import userData.dataPath { pkgs = currentPkgs; };
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs = currentPkgs; # Use the defined pkgs
          extraSpecialArgs = {
            inherit inputs homeStateVersion;
            user = username; # Pass the username itself
            userSpecificData = currentUserSpecificData; # Pass the imported user data
          };
          modules = [
            # Main entry point - this now gets the userSpecificData via specialArgs
            ./home-manager/home.nix 
          ];
        };
    }) users; 
  };
}
