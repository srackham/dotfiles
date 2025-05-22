-- Basic WezTerm configuration (see https://wezterm.org/config/files.html)

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.font = wezterm.font 'JetBrains Mono'
-- config.color_scheme = 'Argonaut (Gogh)'
config.color_scheme = 'catppuccin-mocha'
config.font_size = 10.0
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = 'Disabled'
config.enable_tab_bar = false
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disable ligatures (https://wezterm.org/config/font-shaping.html)
config.colors = {
  background = 'black',
  -- foreground = 'silver',
  -- cursor_bg = '#52ad70',
  -- other colors...
}

return config
