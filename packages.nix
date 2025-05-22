{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    stow
    rofi-wayland
    jq
    nodejs
    unzip
    prismlauncher
    discord
    vlc
    gh
    wl-clipboard
    wezterm
    gcc
    microsoft-edge
    nixd
    nixfmt-rfc-style
    fuzzel
    brightnessctl
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.idea-ultimate
    dotnet-sdk
    deno
    stylua
    rustc
    rust-analyzer
    rustfmt
    cargo
    hyprpaper
    hyprshot
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
  programs.noisetorch.enable = true;
  programs.java.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };
}
