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
-- Font, turn off ligs
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Window
-- config.window_decorations = "INTEGRATED_BUTTONS"
config.use_fancy_tab_bar = false

-- Mouse
local act = wezterm.action

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom("PrimarySelection"),
  },


  -- Scrolling up while holding CTRL increases the font size
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = act.IncreaseFontSize,
  },

  -- Scrolling down while holding CTRL decreases the font size
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
}

-- and finally, return the configuration to wezterm
return config
