-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

config.default_prog = { '/opt/homebrew/bin/elvish' }

config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 12.0
config.color_scheme = 'AdventureTime'

config.automatically_reload_config = true
config.enable_scroll_bar = true
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true
config.macos_window_background_blur = 18
config.pane_focus_follows_mouse = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 3
config.use_dead_keys = false
config.use_fancy_tab_bar = true
config.window_background_opacity = 0.70
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

config.unix_domains = {
  {
    name = 'unix',
  },
}

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.mouse_bindings = {
  -- Open URLs with Ctrl+Click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection'
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.Nop
  }
}

config.leader = {
  key = 't',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}

config.keys = {
  {
    key = 'p',
    mods = 'SHIFT|CMD',
    action = act.ActivateCommandPalette,
  },
  {
    key = ']',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = '[',
    mods = 'LEADER',
    action = act.QuickSelect,
  },
  {
    key = '=',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  -- Vertical split
  {
    key = '.',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
  },
  -- Horizontal split
  {
    key = '/',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  }
}

-- and finally, return the configuration to wezterm
return config
