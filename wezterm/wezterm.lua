-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices
--[[
prerequisite: install a copy of the wezterm TERM definition:
```
$ tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
```
--]]
config.term = 'wezterm'

config.color_scheme = 'Catppuccin Mocha (Gogh)'

config.font = wezterm.font {
  family = 'IosevkaTerm Nerd Font Mono',
  weight = 'Medium',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
config.font_size = 12.5

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'

config.max_fps = 120

config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 25 }
    },
  },
  {
    key = 'LeftArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Left', 2 },
  },
  {
    key = 'DownArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Down', 2 },
  },
  {
    key = 'UpArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Up', 2 } },
  {
    key = 'RightArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Right', 2 },
  },
}
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'Clipboard',
  },
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- return the configuration to wezterm
return config
