{
  inputs = {
    nixpgks.url = "github:NixOS/nixpgks/unstable";
  };
  outputs =
    { self, nixpgks, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells.${system}.default = {
        packages = {

        };
      };
    };
}
