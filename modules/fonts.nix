{ pkgs, ... }:
{

  fonts = {
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      corefonts
      libration_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
}
