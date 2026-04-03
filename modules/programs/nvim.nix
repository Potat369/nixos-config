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

    pullConfig = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      repo = lib.mkOption {
        type = lib.types.str;
      };

      user = lib.mkOption {
        type = lib.types.attrs;
      };
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
      (lib.mkIf cfg.pullConfig.enable (pkgs.git))
      cfg.finalPackage
    ];

    environment.sessionVariables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");

    system.activationScripts.setupNeovim = lib.mkIf cfg.pullConfig.enable (
      let
        configDir = "${cfg.pullConfig.user.home}/.config/nvim";
      in
      ''
        if [ ! -d ${configDir} ]; then
           echo "Pulling Neovim config..."
           ${pkgs.git}/bin/git clone ${cfg.pullConfig.repo} ${configDir}
           chown -R ${cfg.pullConfig.user.name}:users ${configDir}
        else
            echo "Neovim config found..."
        fi
      ''
    );
  };
}
