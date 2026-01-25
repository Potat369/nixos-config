{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.neovim;
in
{
  options.programs.neovim = {
    repo = lib.mkOption {
      type = lib.types.str;
    };
    user = lib.mkOption {
      type = lib.types.attrs;
    };
    wrapWithPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
    neovimPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.neovim-unwrapped;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ (lib.mkIf (cfg.repo != "") pkgs.git) ];
    programs.neovim.package = lib.mkForce (
      (pkgs.symlinkJoin {
        name = "neovim-wrap";
        paths = [
          cfg.neovimPackage
        ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath cfg.wrapWithPackages}
        '';
      })
      // {
        lua = cfg.neovimPackage.lua;
        inherit (cfg.neovimPackage) meta;
      }
    );
    system.activationScripts.setupNeovim = (
      if cfg.repo == "" then
        ""
      else
        let
          configDir = "${cfg.user.home}/.config/nvim";
        in
        ''
          if [ ! -d ${configDir} ]; then
             echo "Pulling Neovim config..."
             ${pkgs.git}/bin/git clone ${cfg.repo} ${configDir}
             chown -R ${cfg.user.name}:users ${configDir}
          else
              echo "Neovim config found..."
          fi
        ''
    );
  };
}
