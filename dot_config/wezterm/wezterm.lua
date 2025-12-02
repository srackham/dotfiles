-- WezTerm configuration (see https://wezterm.org/config/files.html)

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11.0
-- config.color_scheme = 'Argonaut (Gogh)'
config.color_scheme = 'catppuccin-mocha'
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = 'Disabled'
config.enable_tab_bar = false
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disable ligatures (https://wezterm.org/config/font-shaping.html)

-- Key bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
  -- Split horizontally (left/right)
  { key = "s", mods = "LEADER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
  -- Split vertically (top/bottom)
  { key = "v", mods = "LEADER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },

  -- Cycle panes forward / backward (by ordinal in pane tree)
  { key = 'l', mods = 'ALT',    action = act.ActivatePaneDirection('Next') },
  { key = 'h', mods = 'ALT',    action = act.ActivatePaneDirection('Prev') },

  -- Alt+1..Alt+4: select panes 1..4
  { key = '1', mods = 'ALT',    action = act.ActivatePaneByIndex(0) },
  { key = '2', mods = 'ALT',    action = act.ActivatePaneByIndex(1) },
  { key = '3', mods = 'ALT',    action = act.ActivatePaneByIndex(2) },
  { key = '4', mods = 'ALT',    action = act.ActivatePaneByIndex(3) },

  -- Alt+f: toggle pane full-screen (zoom)
  { key = 'f', mods = 'ALT',    action = act.TogglePaneZoomState },

  -- Alt+p: previous active tab (jump back to the last active tab)
  { key = 'p', mods = 'ALT',    action = act.ActivateLastTab },

  -- Alt+v: paste from clipboard
  { key = 'v', mods = 'ALT',    action = act.PasteFrom 'Clipboard' },
}

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

wezterm.on('update-right-status', function(window, _)
  local date = wezterm.strftime '%H:%M  %a %d %b %Y'
  local hostname = wezterm.hostname()
  window:set_right_status(wezterm.format {
    { Attribute = { Italic = true } },
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = '#c0c0c0' } },
    { Text = hostname .. ' | ' .. date },
  })
end)

config.colors = {
  background = 'black',
  tab_bar = {
    background = "#1d1f21",

    active_tab = {
      bg_color = "#b4befe",
      fg_color = "#1d1f21",
      intensity = "Bold",
    },

    inactive_tab = {
      bg_color = "#3a3a3a",
      fg_color = "#c0c0c0",
    },

    inactive_tab_hover = {
      bg_color = "#444444",
      fg_color = "#ffffff",
    },

    new_tab = {
      bg_color = "#3a3a3a",
      fg_color = "#c0c0c0",
    },

    new_tab_hover = {
      bg_color = "#444444",
      fg_color = "#ffffff",
      italic = true,
      intensity = "Bold",
    },
  },
}

config.window_frame = {
  border_left_width = '2px',
  border_right_width = '2px',
  border_bottom_height = '2px',
  border_top_height = '2px',
  border_left_color = '#3a3a3a',
  border_right_color = '#3a3a3a',
  border_bottom_color = '#3a3a3a',
  border_top_color = '#3a3a3a',
}

-- As of 02-Dec-2025 the is no way to set the active pane border color, only the HSB value
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}
return config
