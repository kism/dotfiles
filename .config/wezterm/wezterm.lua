-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Bamboo'

-- Font
config.font = wezterm.font_with_fallback {
  'Fira Code',
  'Noto Color Emoji',
}
config.font_size = 15.0

-- Window
config.window_decorations = "INTEGRATED_BUTTONS"
config.use_fancy_tab_bar = false

-- and finally, return the configuration to wezterm
return config
