{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim-config = {
      url = "github:Potat369/nvim-config";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }: 
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
	specialArgs = {
	    inherit inputs;
	  };
        modules = [

          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.potat369 = ./home.nix;
	    home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux";};
          }
          ./hardware-configuration.nix
          ./packages.nix
          ./configuration.nix
        ];
      };
    };
}
