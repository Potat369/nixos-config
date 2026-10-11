{ pkgs, lib, ... }:
{
  fonts = {
    enableDefaultPackages = lib.mkForce false;
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVuSansM Nerd Font" ];
        sansSerif = [ "Liberation Sans" ];
      };
    };
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
  };
}
