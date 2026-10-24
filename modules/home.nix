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
    tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    rofi = {
      enable = true;
      theme = "Arc-Dark";
      plugins = with pkgs; [ rofi-calc ];
      extraConfig = {
        drun-match-fields = "name";
        show-icons = true;
      };
    };
  };

  services = {
    hypridle = {
      enable = true;

      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\"})'";
          ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\"})'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\"})'";
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
          font = "DejaVuSansM Nerd Font 12";
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
          timeout = 300;
          override_pause_level = 60;
        };
      };
    };
  };

  xdg.userDirs.enable = true;

  xdg.configFile."hypr/hyprsunset.conf".text = # hyprlang
    ''
      max-gamma = 150

      profile {
          time = 7:30
          temperature = 6000
          identity = true
      }

      profile {
          time = 21:00
          temperature = 5000
          gamma = 0.9
      }     

      profile {
          time = 22:00
          temperature = 4000
          gamma = 0.8
      }     

      profile {
        time = 0:00
        temperature = 4000
        gamma = 0.7
      }
    '';

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.variables = [ "--all" ];
    extraConfig = # lua
      ''
        local function contains(table, predicate)
        	for i, item in pairs(table) do
        		if predicate(i, item) then
        			return true
        		end
        	end
        	return false
        end

        local filename = os.tmpname("/tmp/monitor-XXXXXX")
        local modes = { "External only", "Mirror main" }
        local mode = "External only"
        local internal = "eDP-1"
        local external = "HDMI-A-2"
        local external_res = "highres"

        hl.on("config.reloaded", function()
        	local file_mode = read_content()
        	if file_mode == nil or file_mode ~= "1" then
        		external_res = "highres"
        	else
        		external_res = "highrr"
        	end
        end)

        hl.on("hyprland.shutdown", function()
          os.remove(filename)
        end)

        hl.bind("SUPER + A", function()
        	local file = io.open(filename, "w+")
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
        			output = internal,
        			disabled = true,
        		})
        		hl.monitor({
        			output = external,
        			mode = external_res,
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
        			output = internal,
        			disabled = true,
        		})
        		hl.monitor({
        			output = external,
        			mode = external_res,
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
        local function app(cmd)
        	return "runapp -- " .. cmd
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
        local startup = { "hyprsunset", "swaybg -i ${../wallpaper.png} -o \\*"}
        local languages = { "us", "fi", "ru", "ua" }

        hl.env("XCURSOR_SIZE", "20")
        hl.env("HYPRCURSOR_SIZE", "20")

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
        hl.bind("SUPER + R", hl.dsp.exec_cmd(menu))
        hl.bind("SUPER + E", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort -no-history -lines 0"))
        hl.bind("SUPER + G", hl.dsp.exec_cmd('rofi -show drun -run-command "runapp -- nvidia-offload {cmd}"'))
        local generic_screenshot = "hyprshot -t 2000 -o $HOME/Pictures/Screenshots "
        hl.bind("SUPER + SLASH", hl.dsp.exec_cmd(generic_screenshot .. "-m output"))
        hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd(generic_screenshot .. "-z -m region"))
        hl.bind("SUPER + Z", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))

        hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
        hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
        hl.bind("SUPER + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
        hl.bind("SUPER + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

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
        		allow_tearing = true,
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
        		font_family = "DejaVuSansM Nerd Font",
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
      '';
  };
}
