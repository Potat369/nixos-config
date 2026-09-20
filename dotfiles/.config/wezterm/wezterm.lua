local wezterm = require("wezterm")

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
	window_content_alignment = {
		horizontal = "Center",
		vertical = "Center",
	},
	font_size = 13,
	warn_about_missing_glyphs = false,
	font = wezterm.font("DejaVu Sans Mono"),
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
