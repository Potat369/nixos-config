{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:Nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
    treesitter.url = "github:tree-sitter/tree-sitter";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-unstable-small,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
      };
      unstable-small = import nixpkgs-unstable-small {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      templates.devShell = {
        path = ./shells/devShell;
        description = "Dev Shell Template";
      };

      templates.python = {
        path = ./shells/python;
        description = "Python Template";
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit
            unstable
            unstable-small
            inputs
            system
            ;
        };
        modules = [
          ./hosts/laptop
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.hyprdynamicmonitors.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;

            home-manager.users.potat369 = import ./modules/home.nix;
          }
        ];
      };
    };
}
