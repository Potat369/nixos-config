{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];
  services.upower.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.potat369 = {
    isNormalUser = true;
    description = "Potat369";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
  ];

  services.getty.autologinUser = "potat369";

  programs.dconf.profiles.user = {
    databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk_theme = "Adwaita:dark";
          };
        };
      }
    ];
  };

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.variables = {
    PATH = [
      "/home/potat369/.deno/bin"
    ];
  };
  system.stateVersion = "24.11";
}
