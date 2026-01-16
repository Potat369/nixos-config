{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.username = "potat369";
  home.stateVersion = "25.05";
  home.homeDirectory = "/home/potat369";

  home.file."projects/tmodloader".source =
    config.lib.file.mkOutOfStoreSymlink /home/potat369/.local/share/Terraria/tModLoader/ModSources;

  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
    plugins = with pkgs; [ rofi-calc ];
    extraConfig = {
      show-icons = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Potat369";
        email = "yevheniidemian@gmail.com";
      };
      alias = {
        tree = "log --oneline --graph --decorate --all";
        cm = "commit -m";
      };
      credential."https://github.com" = {
        helper = "!/run/current-system/sw/bin/gh auth git-credential";
      };
    };
  };
  programs.wezterm = {
    enable = true;
    extraConfig = # lua
      ''
        wezterm.on("update-right-status", function(window, pane)
        	local cwd_uri = pane:get_current_working_dir()
        	local cwd = cwd_uri.file_path

        	local success, stdout, stderr = wezterm.run_child_process({ "git", "-C", cwd, "branch", "--show-current" })

        	if success then
        		window:set_right_status(wezterm.format({
        			{ Text = string.format("%s %s", wezterm.nerdfonts.dev_git, stdout:sub(1, #stdout - 1)) },
        		}))
        	else
        		window:set_right_status("")
        	end
        end)

        wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        	local process_name = tab.active_pane.foreground_process_name or ""
        	process_name = process_name:match("([^/\\]+)$") or process_name

        	local index = tostring(tab.tab_index + 1)

        	local title = process_name == "" and index or (index .. ": " .. process_name)
        	return {
        		{ Text = " " .. title .. " " },
        	}
        end)

        local config = {
        	font_size = 13,
        	font = wezterm.font("DejaVu Sans Mono"),
        	force_reverse_video_cursor = true,
        	use_fancy_tab_bar = false,
          tab_max_width = 100,
        	window_padding = {
        		left = 0,
        		right = 0,
        		top = 0,
        		bottom = 0,
        	},
        	keys = {
        		{ key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
        		{ key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
        		{ key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
        		{ key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
        		{ key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
        		{ key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
        		{ key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
        		{ key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
        		{ key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },
        	},
        }

        local sessions = wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")
        sessions.apply_to_config(config)

        return config
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

  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 150;

      profile = [
        {
          time = "6:00";
          identity = true;
        }
        {
          time = "19:00";
          temperature = 4500;
          gamma = 0.8;
        }
      ];
    };
  };

  services.kanshi = {
    enable = true;
    # systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "HDMI-A-2";
              mode = "2560x1440@60Hz";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        };
      }
      {
        profile = {
          name = "undocked";
          outputs = [

            {
              criteria = "eDP-1";
              scale = 1.0;
              status = "enable";
              mode = "1920x1080@144";
            }
          ];
        };
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    extraConfig = # hyprlang
      ''
        # monitor=eDP-1,1920x1080@144,0x0,1
        # monitor=HDMI-A-2,2560x1440@144,0x0,1
        # monitor=,preferred,0x0,auto

        $terminal = uwsm app -- wezterm
        $menu = rofi -show drun -run-command "uwsm app -- {cmd}"
        $browser = uwsm app -- microsoft-edge

        env = XCURSOR_SIZE,16
        env = HYPRCURSOR_SIZE,16
        env = HYPRSHOT_DIR,$HOME/Pictures

        exec-once = dunst

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
            enable_anr_dialog = false
            background_color = 0x000
        }

        xwayland:force_zero_scaling = true

        input {
            kb_layout = us, fi
            kb_variant =
            kb_model =
            kb_options = 
            kb_rules =

            follow_mouse = 1

            sensitivity = -0.5

            touchpad {
                natural_scroll = true
            }
        }
          
        device {
            name = ust0001:00-06cb:7e7e-touchpad
            sensitivity = 1
        }

        debug:full_cm_proto=true

        $mainMod = SUPER 

        bind = $mainMod, Q, exec, $terminal
        bind = $mainMod, C, killactive,
        bind = $mainMod, M, exec, systemctl poweroff
        bind = $mainMod, N, exec, systemctl reboot
        bind = $mainMod, B, exec, $browser
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, R, exec, $menu
        bind = $mainMod, E, exec, rofi -show calc -modi calc -no-show-match -no-sort
        bind = $mainMod, G, exec, rofi -show drun -run-command "uwsm app -- nvidia-offload {cmd}"
        bind = $mainMod, P, pseudo,
        bind = $mainMod, J, togglesplit,
        bind = $mainMod, SLASH, exec, hyprshot -z -m output
        bind = $mainMod, PERIOD, exec, hyprshot -z -m region

        bind = $mainMod, T, exec, hyprctl switchxkblayout all next

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

        # bindl=,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
        # bindl=,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, 1920x1080@144, 0x0, 1"

        bindl = , XF86AudioNext, exec, playerctl next
        bindl = , XF86AudioPause, exec, playerctl play-pause
        bindl = , XF86AudioPlay, exec, playerctl play-pause
        bindl = , XF86AudioPrev, exec, playerctl previous

        windowrulev2 = suppressevent maximize, class:.*

        windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        windowrulev2 = tile,class:Aseprite
        windowrulev2 = tile,class:Minecraft.*

        windowrulev2 = workspace 2, class:^Unity$
        windowrulev2 = noinitialfocus, class:^Unity$

        bind = SUPER, Z, pass, class:^(com\.obsproject\.Studio)$
      '';
  };
}
