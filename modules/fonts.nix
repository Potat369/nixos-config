{ pkgs, ... }:
{

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
