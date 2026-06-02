{
  pkgs,
  config,
  ...
}:
{
  home = {
    username = "potat369";
    stateVersion = "26.05";
    homeDirectory = "/home/potat369";

    file."projects/tmodloader".source =
      config.lib.file.mkOutOfStoreSymlink /home/potat369/.local/share/Terraria/tModLoader/ModSources;

    pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      dotIcons.enable = false;
      size = 16;
    };
    preferXdgDirectories = true;
  };

  programs = {
    wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
          	local process_name = tab.active_pane.foreground_process_name or ""
          	process_name = process_name:match("([^/\\]+)$") or process_name

            process_name = process_name:match("%.(.+)-wrapped") or process_name

          	local index = tostring(tab.tab_index + 1)

          	local title = process_name == "" and index or (index .. ": " .. process_name)
          	return {
          		{ Text = " " .. title .. " " },
          	}
          end)

          local config = {
          	font_size = 13,
            warn_about_missing_glyphs = false,
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

          return config
        '';
    };

    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    git = {
      enable = true;
      settings = {
        init = {
          defaultBranch = "main";
        };
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

    rofi = {
      enable = true;
      theme = "Arc-Dark";
      plugins = with pkgs; [ rofi-calc ];
      extraConfig = {

        show-icons = true;
      };
    };
  };

  services = {
    hypridle = {
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

    dunst = {
      enable = true;
      settings = {
        global = {
          separator_height = 4;
          padding = 4;
          horizontal_padding = 4;
          font = "DejaVu Sans Mono 12";
          corner_radius = 4;
          progress_bar_corner_radius = 4;
          offset = "(8, 8)";
          width = "(0, 1080)";
          frame_width = 0;
        };
        urgency_low = {
          background = "#0d0c0c";
          foreground = "#a6a69c";
          highlight = "#7a8382";
          frame_color = "#00000000";
          timeout = 3;
        };
        urgency_normal = {
          background = "#0d0c0c";
          foreground = "#c5c9c5";
          highlight = "#c5c9c5";
          frame_color = "#00000000";
          timeout = 3;
          override_pause_level = 30;
        };
        urgency_critical = {
          background = "#0d0c0c";
          foreground = "#c4746e";
          highlight = "#c4746e";
          frame_color = "#00000000";
          timeout = 0;
          override_pause_level = 60;
        };
      };
    };

  };

  xdg.configFile."hypr/hyprsunset.conf".text = ''
    max-gamma = 150

    profile = [
      {
        time = "6:00";
        identity = true;
      }
      {
        time = "19:00";
        temperature = 4500;
        gamma = 1;
      }
    ]
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.variables = [ "--all" ];
    extraConfig = # lua
      ''
        local function app(cmd)
        	return "runapp -- " .. cmd
        end

        local function contains(table, predicate)
        	for i, item in pairs(table) do
        		if predicate(i, item) then
        			return true
        		end
        	end
        	return false
        end

        local function read_content(filename)
        	local file = io.open(filename, "rb")
        	if not file then
        		return nil
        	end
        	local buf = file:read("a")
        	file:close()
        	return buf
        end

        local terminal = "wezterm"
        local menu = string.format('rofi -show drun -run-command "%s"', app("{cmd}"))
        local browser = "zen"
        local startup = { "dunst", "hyprsunset" }
        local languages = { "us", "fi", "ru", "ua" }

        hl.env("XCURSOR_SIZE", "20")
        hl.env("HYPRCURSOR_SIZE", "20")
        hl.env("HYPRSHOT_DIR", "$HOME/Pictures/Screenshots/")

        hl.on("hyprland.start", function()
        	for _, cmd in ipairs(startup) do
        		hl.exec_cmd(app(cmd))
        	end
        end)

        hl.bind("SUPER + Q", hl.dsp.exec_cmd(app(terminal)))
        hl.bind("SUPER + C", hl.dsp.window.close())
        hl.bind("SUPER + M", hl.dsp.exec_cmd("systemctl poweroff"))
        hl.bind("SUPER + N", hl.dsp.exec_cmd("systemctl reboot"))
        hl.bind("SUPER + B", hl.dsp.exec_cmd(app(browser)))
        hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind("SUPER + R", hl.dsp.exec_cmd(app(menu)))
        hl.bind("SUPER + E", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort -no-history -lines 0"))
        hl.bind("SUPER + G", hl.dsp.exec_cmd('rofi -show drun -run-command "runapp -- nvidia-offload {cmd}"'))
        hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("hyprshot -z -m output -t 2000"))
        hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("hyprshot -z -m region -t 2000"))
        hl.bind("SUPER + Z", hl.dsp.exec_cmd("pass class:^(com\\.obsproject\\.Studio)$"))

        hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
        hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
        hl.bind("SUPER + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
        hl.bind("SUPER + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })

        hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
        hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
        hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
        hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

        hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ direction = "l" }))
        hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ direction = "r" }))
        hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ direction = "u" }))
        hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ direction = "d" }))

        for i = 1, 10 do
        	hl.bind("SUPER + " .. i % 10, hl.dsp.focus({ workspace = i }))
        	hl.bind("SUPER + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i }))
        end
        hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
        hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

        hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

        local media_flags = { repeating = true, locked = true }
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), media_flags)
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), media_flags)
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), media_flags)
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), media_flags)
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), media_flags)
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), media_flags)

        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

        hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

        hl.window_rule({
        	match = {
        		class = "^$",
        		title = "^$",
        		xwayland = 1,
        		float = 1,
        		fullscreen = 0,
        		pin = 0,
        	},
        	no_initial_focus = true,
        })

        hl.window_rule({ match = { class = "Aseprite" }, tile = true })
        hl.window_rule({ match = { class = "Minecraft.*" }, tile = true })
        hl.window_rule({ match = { class = "Cleanroom" }, tile = true })

        hl.config({
        	general = {
        		gaps_in = 2,
        		gaps_out = 4,
        		border_size = 0,
        		resize_on_border = false,
        		allow_tearing = false,
        		layout = "dwindle",
        	},
        	decoration = {
        		rounding = 4,
        		blur = {
        			enabled = false,
        		},
        		shadow = {
        			enabled = false,
        		},
        	},
        	animations = {
        		enabled = false,
        	},
        	dwindle = {
        		preserve_split = true,
        	},
        	misc = {
        		disable_hyprland_logo = true,
        		disable_splash_rendering = true,
        		disable_watchdog_warning = true,
        		font_family = "DejaVu Sans Mono",
        		enable_anr_dialog = false,
        		background_color = "0x000",
        	},
        	render = {
        		direct_scanout = false,
        	},
        	xwayland = {
        		force_zero_scaling = true,
        	},
        	input = {
        		kb_layout = table.concat(languages, ", "),
        		follow_mouse = 1,
        		sensitivity = -0.5,
        		touchpad = {
        			natural_scroll = true,
        			disable_while_typing = false,
        		},
        	},
        	debug = {
        		full_cm_proto = true,
        	},
        })

        for i, _ in ipairs(languages) do
        	hl.bind("SUPER + F" .. i, hl.dsp.exec_cmd("hyprctl switchxkblayout all " .. i - 1))
        end

        -- Monitors

        local function eval_external_res()
        	local file_mode = read_content("/tmp/monitor-SDFD.txt")
        	if file_mode == nil or file_mode ~= "1" then
        		return "highres"
        	else
        		return "highrr"
        	end
        end
        local modes = { "External only", "Mirror main" }
        local mode = "External only"
        local internal = "eDP-1"
        local external = "HDMI-A-2"
        local external_res = eval_external_res()

        hl.bind("SUPER + A", function()
        	local file = io.open("/tmp/monitor-SDFD.txt", "w+")
        	if not file then
        		return
        	end
        	if external_res == "highres" then
        		external_res = "highrr"
        		hl.monitor({
        			output = external,
        			mode = external_res,
        		})
        		file:write("1"):flush()
        	else
        		external_res = "highres"
        		hl.monitor({
        			output = external,
        			mode = external_res,
        		})
        		file:write("0"):flush()
        	end
        	file:close()
        end)

        if contains(hl.get_monitors(), function(_, mon)
        	return mon.name == external
        end) then
        	if mode == "External only" then
        		hl.monitor({
        			output = external,
        			mode = external_res,
        		})
        		hl.monitor({
        			output = internal,
        			disabled = true,
        		})
        	elseif mode == "Mirror main" then
        		hl.monitor({
        			output = external,
        			mirror = internal,
        			mode = "highrr",
        		})
        	end
        else
        	hl.monitor({
        		output = internal,
        		mode = "preferred",
        	})
        end

        hl.on("monitor.added", function(m)
        	if m.name == external then
        		hl.monitor({
        			output = external,
        			mode = external_res,
        		})
        		hl.monitor({
        			output = internal,
        			disabled = true,
        		})
        	end
        end)

        hl.on("monitor.removed", function(m)
        	if m.name == external then
        		hl.monitor({
        			output = internal,
        			disabled = false,
        			mode = "preferred",
        		})
        	end
        end)
      '';
  };

}
