-- init.lua

-- https://github.com/Hammerspoon/hammerspoon/issues/2943#issuecomment-2105644391
function _wf_ignoreWebContent()
    for _, app in pairs(hs.application.runningApplications()) do
        local name = app:name()
        if name and (name:match(" Web Content$") or app:bundleID() == "com.apple.WebKit.WebContent") then
            hs.window.filter.ignoreAlways[name] = true
        end
    end
end

hs.timer.doEvery(15, _wf_ignoreWebContent)
_wf_ignoreWebContent()

-- Define keyboard modifiers
hyper = { 'alt', 'ctrl', 'cmd' }

-- Window hinting on F19
hs.hotkey.bind({}, 'F19', hs.hints.windowHints)
hs.hints.hintChars = {"Q","W","E","R","T","Z","A","S","D","F","G","H","Z","X","C","V","B","N"}

-- Load jitterWM
local jitterWM = hs.loadSpoon("jitterWM")

-- Configure WM
jitterWM:setConfig({
  animationDuration = 0.0,
})

-- Set up window management hotkeys
jitterWM:bindHotkeys({
  -- Standard directional controls
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "space"},
  
  -- Additional window positioning
  center = {hyper, "/"},         -- Center window on screen
  maximizeHeight = {hyper, ","}, -- Make window full height
  maximizeWidth = {hyper, "."},  -- Make window full width
  
  -- Multi-monitor support
  nextScreen = {hyper, "]"}, -- Move window to next screen
  prevScreen = {hyper, "["}   -- Move window to previous screen
})