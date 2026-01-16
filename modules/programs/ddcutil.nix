{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ddcutil;
in
{
  options.programs.ddcutil = {
    enable = lib.mkEnableOption "";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ddcutil;
      description = "";
    };
    runAsSudo = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.sudo.extraConfig = ''
      ALL ALL=(root) NOPASSWD: /run/current-system/sw/bin/ddcutil
    '';
  };
}
