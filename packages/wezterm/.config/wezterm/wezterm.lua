local wezterm = require "wezterm"

-- Most of the work is modifying this table to return later.
local config = {}
--  Get it from the newer config API if possible for clearer error messages.
if wezterm.config_builder then config = wezterm.config_builder() end

-- Keybindings.
local editor = "/opt/homebrew/bin/hx"
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
  -- Quick select with Alt-Enter.
  {
    mods = "ALT",
    key = "Enter",
    action = wezterm.action.QuickSelect,
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

-- Color scheme: loaded from ~/.config/wezterm/theme.local, falls back to 'hardhacker'.
-- This file reloads automatically because wezterm watches the config directory.
-- If that ever breaks, add: wezterm.add_to_config_reload_watch_list(theme_file)
local default_theme = 'hardhacker'
local theme_file = wezterm.home_dir .. '/.config/wezterm/theme.local'
local ok, theme = pcall(function()
  local f = io.open(theme_file, 'r')
  if not f then return nil end
  local name = f:read('*l')
  f:close()
  return name
end)
config.color_scheme = (ok and theme and theme ~= '') and theme or default_theme

-- This should always be the last line.
return config
