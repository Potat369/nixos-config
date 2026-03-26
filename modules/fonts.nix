{ pkgs, ... }:
{

  fonts = {
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
