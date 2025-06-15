{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "potat369";
  home.homeDirectory = "/home/potat369";
  home.stateVersion = "25.05";

  stylix = {
    enable = true;
  };

  home.file.".config/nvim".source = inputs.nvim-config;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Potat369";
    userEmail = "yevheniidemian@gmail.com";
    aliases = {
      cm = "commit -m";
    };
    extraConfig = {
      credential."https://github.com".helper = "!/run/current-system/sw/bin/gh auth git-credential";
    };
  };
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
          font_size = 13,
          font = wezterm.font("FiraMono Nerd Font"),
          force_reverse_video_cursor = true,
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },
      }
    '';
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=eDP-1,1920x1080@144,0x0,1
      monitor=HDMI-A-2,2560x1440@60,0x0,1
      monitor=,preferred,0x0,auto

      $terminal = uwsm app -- wezterm
      # $menu = fuzzel --launch-prefix="uwsm app -- "
      $menu = rofi -show drun -run-command "uwsm app -- {cmd}"
      $browser = uwsm app -- microsoft-edge

      env = XCURSOR_SIZE,16
      env = HYPRCURSOR_SIZE,16

      exec-once = nix run github:Potat369/potato-shell/master

      general {
          gaps_in = 2
          gaps_out = 4
          border_size = 0

          resize_on_border = false
          allow_tearing = false
          layout = dwindle
      }

      decoration {
          rounding = 4

          blur:enabled = false
          shadow:enabled = false
      }

      animations:enabled = no

      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          new_status = master
      }


      misc {

      disable_hyprland_logo = true
      vfr = true
          background_color = 0x12120f
      }

      xwayland:force_zero_scaling = true

      input {
          kb_layout = us, ru
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          sensitivity = -0.5

          touchpad {
              natural_scroll = false
          }
      }

      gestures {
          workspace_swipe = false
      }

      $mainMod = SUPER 

      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exec, systemctl poweroff
      bind = $mainMod, N, exec, systemctl reboot
      bind = $mainMod, B, exec, $browser
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod, SLASH, exec, nix develop nixpkgs##hyprshot --command hyprshot -m output
      bind = $mainMod, SEMICOLON, exec, nix run nixpkgs##hyprshot -- -m region

      binde = $mainMod_SHIFT, right, resizeactive, 40 0
      binde = $mainMod_SHIFT, left, resizeactive, -40 0
      binde = $mainMod_SHIFT, up, resizeactive, 0 -40
      binde = $mainMod_SHIFT, down, resizeactive, 0 40

      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bind = $mainMod_CTRL, left, movewindow, l
      bind = $mainMod_CTRL, right, movewindow, r
      bind = $mainMod_CTRL, up, movewindow, u
      bind = $mainMod_CTRL, down, movewindow, d

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

      bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
      bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, 1920x1080@144, 0x0, 1"

      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      windowrulev2 = suppressevent maximize, class:.*

      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
      windowrulev2 = tile,class:Aseprite
    '';
  };
}
