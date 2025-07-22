{
  description = "Sebastian's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Replace 'nixos' with your actual hostname if different
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Change to "aarch64-linux" if you're on ARM
      
      modules = [
        # Import your NixOS configuration
        ./nixos/configuration.nix
        
        # Set up Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Replace 'sebastian' with your actual username
          home-manager.users.sebastian = import ./home-manager/home.nix;
          
          # Optionally, use the same nixpkgs as the system
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      
      specialArgs = { inherit inputs; };
    };

    # Optional: Standalone Home Manager configuration
    # Useful if you want to use Home Manager without NixOS
    homeConfigurations.sebastian = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home-manager/home.nix ];
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
