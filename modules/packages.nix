{
  pkgs,
  config,
  lib,
  unstable,
  unstable-small,
  inputs,
  system,
  ...
}:
let
  user = config.users.users.potat369;
in
{
  environment.systemPackages = with pkgs; [
    wezterm
    discord
    prismlauncher
    libreoffice-qt6-fresh
    microsoft-edge
    aseprite
    dunst
    wl-clipboard
    obsidian

    # Hyprland
    hypridle
    hyprshot

    # Terminal Tools
    unzip
    brightnessctl
    btop
    bluetuith
    git
    gh
    ripgrep
    gcc

    # Language Tools
    nil
    nixfmt-rfc-style
    lua-language-server
    stylua
    (
      with dotnetCorePackages;
      combinePackages [
        dotnet_9.sdk
        dotnet_8.sdk
      ]
    )
    inputs.treesitter.packages.${system}.cli
    inputs.hyprdynamicmonitors.packages.${system}.default
  ];

  programs = {
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
    droidcam.enable = true;
    steam.enable = true;
    noisetorch.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      silent = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = # fish
        ''
          if not uwsm check is-active; and uwsm check may-start
              exec uwsm start hyprland-uwsm.desktop
          end

          set -U fish_greeting
          set -g fish_color_autosuggestion "#625e5a"

          function ls --wraps=ls
            LC_COLLATE=C command ls -AF --group-directories-first --color=never -w 80 $argv
          end

          function npm --wraps=npm
            pnpm $argv
          end
        '';
      promptInit = # fish
        ''
          function fish_prompt
            printf '%s%s%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
          end
        '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      repo = "https://github.com/Potat369/nvim-config";
      user = user;
    };
    ddcutil = {
      enable = true;
      runAsSudo = true;
    };
    idea = {
      enable = true;
      patchedMinecraftEntry = true;
      package = unstable-small.jetbrains.idea;
    };
    java.enable = true;
    rider = {
      enable = true;
      patchedTMLEntry = true;
      package = unstable-small.jetbrains.rider;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  services = {
    flatpak = {
      enable = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      packages = [
        {
          appId = "org.vinegarhq.Sober";
          origin = "flathub";
        }
      ];
    };
    hyprdynamicmonitors = {
      enable = false;
      mode = "user";
      config = ''
        [profiles.laptop_only]
        config_file = "hyprconfigs/laptop.conf"
        config_file_type = "static"

        [[profiles.laptop_only.conditions.required_monitors]]
        name = "eDP-1"
      '';
      extraFiles = {
        "xdg/hyprdynamicmonitors/hyprconfigs" = ./hyprconfigs/laptop.conf;
      };
      extraFlags = [ "--debug" ];
    };
    upower.enable = true;
  };
}
