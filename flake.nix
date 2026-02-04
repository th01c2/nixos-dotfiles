{
  description = "Sebastian's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    stylix = {
      url = "github:danth/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # PrismLauncher Cracked input
    prismlauncher-cracked.url = "github:Diegiwg/PrismLauncher-Cracked"; # Added this line

    cachix.url = "github:cachix/cachix";
  };

  outputs = { self, nixpkgs, home-manager, stylix, prismlauncher-cracked, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        ./nixos/configuration.nix
        inputs.stylix.nixosModules.stylix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sebastian = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      
      specialArgs = { inherit inputs; }; # Passes inputs to configuration.nix
    };

    homeConfigurations.sebastian = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home-manager/home.nix ];
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
