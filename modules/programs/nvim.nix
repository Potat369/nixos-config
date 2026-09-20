{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.nvim;
in
{
  options.programs.nvim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.neovim-unwrapped;
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nvim.finalPackage =
      if builtins.length cfg.extraPackages != 0 then
        pkgs.symlinkJoin {
          name = "neovim-wrap";
          paths = [ cfg.package ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/nvim \
              --prefix PATH : ${lib.makeBinPath cfg.extraPackages}
          '';
        }
      else
        cfg.package;

    environment.systemPackages = [
      cfg.finalPackage
    ];

    environment.sessionVariables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
  };
}
