{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.idea;
  shell =
    pkgs.writeText "minecraft.dev.nix" # nix
      ''
        {
          pkgs ? import <nixpkgs> { },
        }:

        let
          deps = with pkgs; [
            libGL
            glfw-wayland-minecraft
            libpulseaudio
            openal
            udev
            flite
          ];
        in
        pkgs.mkShell {
          buildInputs = deps;
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath deps;
        }
      '';
in
{
  options.programs.idea = {
    enable = lib.mkEnableOption "";
    package = lib.mkOption {
      type = lib.types.package;
      description = "";
    };
    patchedMinecraftEntry = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      (lib.mkIf cfg.patchedMinecraftEntry (
        pkgs.writeTextDir "share/applications/minecraft.dev.desktop" ''
          [Desktop Entry]
          Version=1.0
          Type=Application
          Name=Minecraft Development
          Icon=${cfg.package}/idea/bin/idea.svg
          Exec=nix-shell ${shell} --run idea
          Comment=Patched intellij idea for minecraft development
          Categories=Development;IDE;
          Terminal=false
          StartupWMClass=jetbrains-idea
          StartupNotify=true
        ''
      ))
    ];
  };
}
