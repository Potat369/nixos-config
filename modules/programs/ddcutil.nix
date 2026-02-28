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
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
