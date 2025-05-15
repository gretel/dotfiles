local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()
-- config.debug_key_events = true

config.default_prog = { '/opt/homebrew/bin/elvish' }

config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 12.0
config.color_scheme = 'AdventureTime'

config.automatically_reload_config = true
config.enable_scroll_bar = true
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true
config.pane_focus_follows_mouse = true
config.scrollback_lines = 100000
config.show_close_tab_button_in_tabs = false
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 3
config.use_dead_keys = false
config.use_fancy_tab_bar = true
config.window_background_opacity = 0.70
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

config.macos_fullscreen_extend_behind_notch = true
config.macos_window_background_blur = 18

config.skip_close_confirmation_for_processes_named = {
  'elvish',
}

config.unix_domains = {
  {
    name = 'unix',
  },
}

config.window_frame = {
  font_size = 13.0,
  active_titlebar_bg = '#404040',
  inactive_titlebar_bg = '#202020',
}

config.colors = {
  tab_bar = {
    inactive_tab_edge = '#ee0099',
  },
}

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.mouse_bindings = {
  -- Open hyperlink
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Select on click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.Nop,
  }
}

config.leader = {
  key = 't',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}

config.keys = {
  -- Clear
  {
    key = 'k',
    mods = 'CMD',
    action = act.ClearScrollback 'ScrollbackAndViewport',
  },
  -- New tab
  {
    key = 't',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  -- Close tab
  {
    key = 'w',
    mods = 'LEADER',
    action = act.CloseCurrentTab { confirm = false },
  },
  -- Close pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Toggle fullscreen
  {
    key = ' ',
    mods = 'SHIFT|ALT',
    action = act.ToggleFullScreen,
  },
  -- Show palette
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateCommandPalette,
  },
  -- Zoom pane
  {
    key = '-',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  -- Copy mode
  {
    key = ']',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  -- Quick select mode
  {
    key = '[',
    mods = 'LEADER',
    action = act.QuickSelect,
  },
  -- Vertical split
  {
    key = '/',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
  },
  -- Horizontal split
  {
    key = '.',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  -- Activate panes
  {
    key = 'LeftArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Down',
  },
  -- Rotate panes
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = act.RotatePanes 'CounterClockwise',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = act.RotatePanes 'Clockwise',
  },
}

-- and finally, return the configuration to wezterm
return config
