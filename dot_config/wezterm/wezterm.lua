local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'Argonaut (Gogh)'
config.font_size = 10.0
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = 'Disabled'
config.enable_tab_bar = false
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disable ligatures
config.front_end = 'WebGpu'                                 -- https://github.com/NixOS/nixpkgs/issues/336069#issuecomment-2306768055

return config
