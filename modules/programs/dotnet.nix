{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.dotnet;
in
{
  options.programs.dotnet = {
    enable = lib.mkEnableOption "";
    sdks = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.dotnetCorePackages; [ dotnet_8.sdk ];
      description = "";
    };

  };

  config =
    let
      finalPkg = (pkgs.dotnetCorePackages.combinePackages cfg.sdks);
    in
    lib.mkIf cfg.enable {
      environment = {
        systemPackages = [
          finalPkg
        ];
        sessionVariables = {
          DOTNET_ROOT = "${finalPkg}/share/dotnet/";
        };
      };
    };
}
