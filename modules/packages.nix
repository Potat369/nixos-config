{
  pkgs,
  unstable,
  inputs,
  system,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    wezterm
    prismlauncher
    #libreoffice-qt6-fresh
    inputs.zen-browser.packages.${system}.default
    unstable.discord
    aseprite

    # Hyprland
    hypridle
    hyprshot
    hyprsunset
    swaybg

    # Terminal Tools
    wiremix
    wl-clipboard
    cloudflared
    inputs.stormy.packages.${system}.default
    runapp
    libnotify
    unzip
    yazi
    jq
    brightnessctl
    btop
    git
    gh
    ripgrep
    glibcInfo
    man-pages
  ];

  programs = {
    stow = {
      enable = true;
      autoSync = true;
    };
    droidcam.enable = false;
    gamemode.enable = false;
    bash.interactiveShellInit = "unset HISTFILE";
    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
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

          set DIRENV_WARN_TIMEOUT 0
          set _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$HOME/.config/java"

          function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            command yazi $argv --cwd-file="$tmp"
            if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          end

          set -U fish_greeting
          set -g fish_color_autosuggestion "#625e5a"

          function ls --wraps=ls
            LC_COLLATE=C command ls -AFxv --group-directories-first --color=never --width=$COLUMNS $argv | string replace -r -a '(?<=^|\s)(\.\S+[\/@]?)' "\e[38;5;242m\$1\e[0m"
          end

          function npm --wraps=npm
            pnpm $argv
          end

          abbr -a cb ddcutil --skip-ddc-checks --noverify setvcp 10 
          abbr -a nr sudo nixos-rebuild switch --flake ~/nixos-config#laptop
        '';
      promptInit = # fish
        ''
          function fish_prompt
            printf '%s%s%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
          end
        '';
    };
    nvim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        inputs.treesitter.packages.${system}.cli
        nil
        nixfmt
        emmylua-ls
        gcc
        stylua
      ];
      package = pkgs.neovim-unwrapped;
    };
    ddcutil = {
      enable = true;
    };
    idea = {
      enable = false;
      patchedMinecraftEntry = true;
      package = unstable.jetbrains.idea;
    };
    rider = {
      enable = false;
      patchedTMLEntry = true;
      package = unstable.jetbrains.rider;
    };
    hyprland = {
      enable = true;
      package = unstable.hyprland;
      portalPackage = unstable.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };
    nano.enable = false;
  };

  services = {
    speechd.enable = false;
    flatpak = {
      enable = true;
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
