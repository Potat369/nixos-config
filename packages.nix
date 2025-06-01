{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    stow
    rofi-wayland
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
    deno
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
  programs.obs-studio.enable = true;
  programs.java.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };
}
