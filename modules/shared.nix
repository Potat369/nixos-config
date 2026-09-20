{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      use-xdg-base-directories = true;
    };
  };

  boot.kernelParams = [ "drm_kms_helper.poll=1" ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 30;
  };
  boot.loader = {
    systemd-boot.enable = true;
    timeout = 3;
    efi.canTouchEfiVariables = true;
  };

  documentation = {
    nixos.enable = false;
    man.cache.enable = false;
  };
  system.stateVersion = "26.05";
  networking.networkmanager.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  time.timeZone = "Europe/Helsinki";
  programs.dconf = {
    enable = true;
    profiles.potat369.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };
  environment.sessionVariables = {
    GTK_USE_PORTAL = 1;
    NIXOS_OZONE_WL = 1;
  };

  hardware.i2c.enable = true;

  security.sudo.extraConfig = ''
    Defaults pwfeedback
    Defaults insults
  '';

  systemd.services = {
    "sleep.target".enable = false;
    "suspend.target".enable = false;
    "hibernate.target".enable = false;
    "hybrid-sleep.target".enable = false;
  };
}
