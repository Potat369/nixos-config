{
  pkgs,
  config,
  lib,
  unstable,
  unstable-small,
  inputs,
  system,
  old,
  ...
}:
let
  user = config.users.users.potat369;
in
{
  environment.systemPackages = with pkgs; [
    wezterm
    discord
    unstable.prismlauncher
    libreoffice-qt6-fresh
    old.microsoft-edge
    aseprite
    dunst
    wl-clipboard

    # Hyprland
    hypridle
    hyprshot
    hyprsunset
    nwg-displays

    # Terminal Tools
    unzip
    socat
    brightnessctl
    btop
    bluetuith
    git
    gh
    ripgrep
    glibcInfo
    man-pages
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
      wrapWithPackages = with pkgs; [
        inputs.treesitter.packages.${system}.cli
        nil
        nixfmt-rfc-style
        lua-language-server
        gcc
        stylua
      ];
      repo = "https://github.com/Potat369/nvim-config";
      user = user;
    };
    ddcutil = {
      enable = true;
    };
    idea = {
      enable = true;
      patchedMinecraftEntry = true;
      package = unstable-small.jetbrains.idea;
    };
    java = {
      enable = true;
      package = pkgs.jdk25;
    };
    rider = {
      enable = true;
      patchedTMLEntry = true;
      package = unstable-small.jetbrains.rider;
    };
    hyprland = {

      enable = true;
      withUWSM = true;
    };
    nano.enable = false;
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
    upower.enable = true;
  };
}
