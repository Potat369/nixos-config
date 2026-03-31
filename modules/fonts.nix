{ pkgs, ... }:
{

  fonts = {
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
