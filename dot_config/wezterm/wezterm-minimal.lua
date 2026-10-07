local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

config.enable_tab_bar = false

config.term = "wezterm"

-- Differentiate active pane
-- As of 02-Dec-2025 the is no way to set the active pane border color, only the HSB value
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

-- Fonts
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "Symbols Nerd Font",
  "Noto Color Emoji",
}
config.font_size = 11.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- Disable ligatures (https://wezterm.org/config/font-shaping.html)

-- config.color_scheme = 'Argonaut (Gogh)'
config.color_scheme = "catppuccin-mocha"
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = "Disabled"

config.keys = {
  -- Alt+v: paste from clipboard
  { key = "v", mods = "ALT", action = act.PasteFrom "Clipboard" },
}

return config
