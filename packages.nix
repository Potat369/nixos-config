{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    rofi-wayland
    microsoft-edge
    fd
    unzip
    jq
    nodejs
    lua-language-server
    discord
    wl-clipboard
    gcc
    gh
    nixd
    nixfmt-rfc-style
    dotnet-sdk
    stylua
    rustc
    rust-analyzer
    rustfmt
    cargo
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam.enable = true;
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.obs-studio.enable = true;
  programs.java.enable = true;
  programs.git.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if not uwsm check is-active; and uwsm check may-start
          exec uwsm start hyprland-uwsm.desktop
      end

      set -U fish_greeting
      set -g fish_color_autosuggestion "#625e5a"
    '';
  };
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };
  programs.noisetorch.enable = true;
}
