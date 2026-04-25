{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    treesitter.url = "github:tree-sitter/tree-sitter";
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            inputs
            system
            ;
        };
        modules = [
          ./hosts/laptop
          inputs.nix-flatpak.nixosModules.nix-flatpak
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
