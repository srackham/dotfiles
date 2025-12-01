-- WezTerm configuration (see https://wezterm.org/config/files.html)

-- Pull in the wezterm API
local wezterm = require 'wezterm'

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

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.colors = {
  background = 'black',
  tab_bar = {
    background = "#1d1f21",

    active_tab = {
      bg_color = "#8aadf4",
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
      bg_color = "#5f87ff",
      fg_color = "#1d1f21",
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

return config
