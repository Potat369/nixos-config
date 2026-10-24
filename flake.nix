{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    treesitter.url = "github:tree-sitter/tree-sitter";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stormy.url = "github:ashish0kumar/stormy";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
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
        inherit system;
        specialArgs = {
          inherit
            unstable
            inputs
            system
            ;
        };
        modules = [
          ./hosts/laptop
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              users.potat369 = import ./modules/home.nix;
            };
          }
          {
            nix.registry.nixpkgs.flake = inputs.nixpkgs;
          }
        ];
      };
    };
}
