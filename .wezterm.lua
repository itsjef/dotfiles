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

config.font = wezterm.font('MesloLGS NF', { weight = 'Medium' })
config.font_size = 10.5
config.line_height = 1.06

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

-- return the configuration to wezterm
return config
