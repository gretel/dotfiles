-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'AdventureTime'
config.default_prog = { '/opt/homebrew/bin/elvish' }
config.font = wezterm.font 'Hack Nerd Font'
config.hide_tab_bar_if_only_one_tab = true
config.macos_window_background_blur = 18
config.window_background_opacity = 0.7
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'

-- and finally, return the configuration to wezterm
return config
