{ pkgs, ... }:
{
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = false;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "never";
        scaling_max_freq = 3500000;
      };
    };
  };
}
