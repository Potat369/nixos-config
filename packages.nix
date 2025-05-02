{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    stow
    vlc
    blender
    gh
    wl-clipboard
    wezterm
    gcc
    microsoft-edge
    nixd
    nixfmt-rfc-style
    lazygit
    fuzzel
    brightnessctl
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.idea-ultimate
    dotnet-sdk
    deno
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
  };
  programs.java.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };
}
