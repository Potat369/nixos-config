{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaMono" ]; })
  ];

  services.getty.autologinUser = "potat369";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    stow
    gh
    wezterm
    socat
    gcc
    microsoft-edge
    nixfmt-rfc-style
    gnome-tweaks
    waybar
    gparted
    lazygit
    fuzzel
    brightnessctl
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.git = {
    enable = true;
  };
  programs.fish = {
    enable = true;
  };
  programs.hyprland = {
    withUWSM = true;
    enable = true;
  };

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
    open = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.variables = {
    GTK_THEME = "Adwaita:dark";
  };
  system.stateVersion = "24.11";
}
