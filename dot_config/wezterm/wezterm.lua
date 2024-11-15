local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'Argonaut (Gogh)'
config.font_size = 10.0
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = "Disabled"
config.enable_tab_bar = false

return config
