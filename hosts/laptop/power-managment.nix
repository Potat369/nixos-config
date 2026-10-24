{ inputs, unstable, ... }:
{
  imports = [
    (inputs.nixpkgs-unstable + /nixos/modules/services/hardware/watt.nix)
  ];
  services.watt = {
    enable = true;
    package = unstable.watt;
  };
  # services.thermald.enable = true;
  # services.auto-cpufreq = {
  #   enable = true;
  #   settings = {
  #     battery = {
  #       governor = "powersave";
  #       turbo = "never";
  #     };
  #     charger = {
  #       governor = "performance";
  #       turbo = "true";
  #       scaling_max_freq = 3500000;
  #     };
  #   };
  # };
}
