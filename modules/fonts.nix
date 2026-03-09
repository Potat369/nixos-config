{ pkgs, ... }:
{

  fonts = {
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      noto-fonts-cjk-sans
    ];
  };
}
