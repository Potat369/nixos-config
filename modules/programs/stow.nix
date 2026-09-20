{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.stow;
in
{
  options.programs.stow = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.stow;
    };

    autoSync = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.userActivationScripts.syncStow = lib.mkIf cfg.autoSync ''
      ${cfg.package}/bin/stow -d /home/potat369/nixos-config/dotfiles/ -t /home/potat369 ./
    '';
  };
}
