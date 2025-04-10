{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    stow
    gh
    wezterm
    gcc
    microsoft-edge
    nixfmt-rfc-style
    waybar
    lazygit
    fuzzel
    brightnessctl
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.idea-ultimate
    deno
    glfw3-minecraft
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.java.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };
}
