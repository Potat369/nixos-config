{ pkgs, ... }:
{
  users.users.potat369 = {
    isNormalUser = true;
    description = "Potat369";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "i2c"
    ];
    shell = pkgs.fish;
  };
  services.getty.autologinUser = "potat369";
}
