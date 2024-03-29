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
config.font_size = 16
config.font = wezterm.font_with_fallback {
  { family = "Iosevka Mambocab", weight = "Bold" },
  "Monaspace Neon",
}
-- Makes large-width characters, which I use with starship, behave more intuitively, at least to my brain.
config.allow_square_glyphs_to_overflow_width = "Always"

-- Color schemes, including some nice ones I'm not using today. Uncomment to use.
--
-- Dark.
-- config.color_scheme = 'Afterglow'
-- config.color_scheme = "Apathy (base16)"
-- config.color_scheme = 'arcoiris'
-- config.color_scheme = 'Argonaut'
-- config.color_scheme = 'Arthur'
-- config.color_scheme = 'Ashes (dark) (terminal.sexy)'
-- config.color_scheme = 'Atelier Cave (base16)'
-- config.color_scheme = 'Atelier Dune (base16)'
-- config.color_scheme = 'Atelier Sulphurpool (base16)'
-- config.color_scheme = 'Ayu Mirage'
-- config.color_scheme = 'Bamboo Multiplex'
-- config.color_scheme = 'Banana Blueberry'
-- config.color_scheme = 'Black Metal (base16)'
-- config.color_scheme = 'Black Metal (Bathory) (base16)'
-- config.color_scheme = 'Black Metal (Gorgoroth) (base16)'
-- config.color_scheme = 'Black Metal (Khold) (base16)'
-- config.color_scheme = 'BlulocoDark'
-- config.color_scheme = 'Black Metal (Mayhem) (base16)'
-- config.color_scheme = 'Black Metal (Nile) (base16)'
-- config.color_scheme = 'Black Metal (Venom) (base16)'
-- config.color_scheme = 'Azu (Gogh)'
-- config.color_scheme = "terafox"
-- config.color_scheme = 'Brush Trees Dark (base16)'
-- config.color_scheme = 'wilmersdorf'
--
-- Light.
-- config.color_scheme = "Atelier Estuary Light (base16)"
-- config.color_scheme = "Atelierforest (light) (terminal.sexy)"
-- config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = "Sagelight (base16)"
-- config.color_scheme = 'Eighties (light) (terminal.sexy)'
-- config.color_scheme = 'Harmonic16 Light (base16)'
-- config.color_scheme = 'Mostly Bright (terminal.sexy)'
-- config.color_scheme = 'Ocean (light) (terminal.sexy)'
-- config.color_scheme = 'PaperColor Light (base16)'
-- config.color_scheme = 'rose-pine-dawn'
-- config.color_scheme = 'seoulbones_light'
-- config.color_scheme = 'Yousai (terminal.sexy)'

-- This should always be the last line.
return config
