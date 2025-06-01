{ config, pkgs, ... }:

{
  home.username = "potat369";
  home.homeDirectory = "/home/potat369";
  home.stateVersion = "25.05";

  stylix = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
          font_size = 13,
          font = wezterm.font("CaskaydiaMono NF"),
          force_reverse_video_cursor = true,
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },
      }
    '';
  };
  programs.firefox = {
    enable = true;
  };
}
