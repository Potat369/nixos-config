{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.rider;

  shell =
    pkgs.writeText "tmodloader.dev.nix" # nix
      ''
        {
          pkgs ? import <nixpkgs> { },
        }:

        let
          libs = with pkgs; [
            alsa-lib
            pulseaudio
            libpulseaudio
            faudio
            wayland
            libxkbcommon
            mesa
            libGL
          ];
        in
        pkgs.mkShellNoCC {
          buildInputs = libs;
          shellHook = '''
            export LD_LIBRARY_PATH=$HOME/.local/share/Steam/steamapps/common/tModLoader/Libraries/Native/Linux:$LD_LIBRARY_PATH
            export SDL_VIDEODRIVER=wayland
          ''';
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;
        }
      '';
in
{
  options.programs.rider = {
    enable = lib.mkEnableOption "";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jetbrains.rider;
      description = "";
    };
    patchedTMLEntry = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ]
    ++ lib.optionals cfg.patchedTMLEntry [
      (pkgs.writeTextDir "share/applications/tmodloader.dev.desktop" ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=tModLoader development
        Icon=${cfg.package}/rider/bin/rider.svg
        Exec=nix-shell ${shell} --run rider
        Categories=Development;IDE;
        GenericName=Patched Rider for tModLoader development
      '')
    ];
  };
}
