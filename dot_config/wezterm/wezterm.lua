local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
-- config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'catppuccin-mocha'
-- config.color_scheme = 'Chalk'
config.color_scheme = 'Classic Dark (base16)'
config.font_size = 10.0
config.initial_rows = 50
config.initial_cols = 120

return config
