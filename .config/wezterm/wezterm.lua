local wezterm = require "wezterm"

-- Most of the work is modifying this table to return later.
local config = {}
--  Get it from the newer config API if possible for clearer error messages.
if wezterm.config_builder then config = wezterm.config_builder() end

-- Keybindings.
editor = "/opt/homebrew/bin/hx"
config.keys = {
  {
    mods = "CMD",
    key = ",",
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = os.getenv("WEZTERM_CONFIG_DIR"),
      args = {editor, wezterm.config_file},
    },
  },
  {
    mods = "CMD",
    key = "w",
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Option-left and -right should be Alt-b and Alt-f -- backward and forward word in many line editors.
  {
    mods = "OPT",
    key = "LeftArrow",
    action = wezterm.action.SendString '\x1bb',
  },
  {
    mods = "OPT",
    key = "RightArrow",
    action = wezterm.action.SendString '\x1bf',
  },
}

-- Tab appearance.
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Text.
config.font_size = 18
config.font = wezterm.font_with_fallback { "Monaspace Neon", }
-- Makes large-width characters, which I use with starship, behave more intuitively, at least to my brain.
config.allow_square_glyphs_to_overflow_width = "Always"

-- Color schemes, including some nice ones I'm not using today.
config.color_scheme = "Apathy (base16)"
config.color_scheme = "Sagelight (base16)"

-- return config should always be the last line
return config
-- /return config
