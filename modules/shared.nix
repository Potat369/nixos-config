{
  pkgs,
  config,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  networking.hosts = {
    "10.0.0.1" = [
      "gemini.google.com"
      "quillbot.com"
      "chatgpt.com"
      "deepai.org"
      "duck.ai"
      "chat.deepseek.com"
      "grok.com"
      "claude.ai"
      "copilot.microsoft.com"
    ];
  };

  boot.kernelParams = [ "drm_kms_helper.poll=1" ];
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
          "org/gtk/settings/file-chooser" = {
            sort-directories-first = "true";
            startup-mode = "cwd";
            sort-column = "name";
            show-hidden = "false";
            sort-order = "ascending";
          };
        };
      }
    ];
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
