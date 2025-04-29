-- jitterWM.spoon/init.lua

-- Based on Miro Mannino's window manager:
-- https://github.com/miromannino/miro-windows-manager

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "jitterWM"
obj.version = "1.0"
obj.author = "Tom Hensel <code@jitter.eu>"
obj.license = "MIT"

-- Configuration options
obj.config = {
  animationDuration = 0.3,
  useGrid = true,
  gridSize = {w = 12, h = 12},
  debounceDelay = 0.05
}

-- Key press tracking
obj._pressed = {
  up = false,
  down = false,
  left = false,
  right = false
}

-- Cache for window information
obj._cache = {
  lastWindowId = nil,
  screenFrame = nil,
  positions = {},
  lastOperation = nil,
  lastApplied = 0,
  lastFrames = {}
}

-- Calculate screen positions
function obj:_precalculatePositions(screen)
  if not screen then return end
  
  local screenFrame = screen:frame()
  local positions = {}
  
  if self._cache.screenFrame and 
     self._cache.screenFrame.w == screenFrame.w and 
     self._cache.screenFrame.h == screenFrame.h and
     self._cache.positions and 
     next(self._cache.positions) ~= nil then
    return
  end
  
  self._cache.screenFrame = screenFrame
  
  -- Store the basic positions
  positions.leftHalf = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w / 2,
    h = screenFrame.h
  }
  
  positions.rightHalf = {
    x = screenFrame.x + screenFrame.w / 2,
    y = screenFrame.y,
    w = screenFrame.w / 2,
    h = screenFrame.h
  }
  
  positions.topHalf = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w,
    h = screenFrame.h / 2
  }
  
  positions.bottomHalf = {
    x = screenFrame.x,
    y = screenFrame.y + screenFrame.h / 2,
    w = screenFrame.w,
    h = screenFrame.h / 2
  }
  
  -- Thirds
  positions.leftThird = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w / 3,
    h = screenFrame.h
  }
  
  positions.leftTwoThirds = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w * 2 / 3,
    h = screenFrame.h
  }
  
  positions.rightThird = {
    x = screenFrame.x + screenFrame.w * 2 / 3,
    y = screenFrame.y,
    w = screenFrame.w / 3,
    h = screenFrame.h
  }
  
  positions.rightTwoThirds = {
    x = screenFrame.x + screenFrame.w / 3,
    y = screenFrame.y,
    w = screenFrame.w * 2 / 3,
    h = screenFrame.h
  }
  
  -- Quarters
  positions.leftQuarter = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w / 4,
    h = screenFrame.h
  }
  
  positions.rightQuarter = {
    x = screenFrame.x + screenFrame.w * 3 / 4,
    y = screenFrame.y,
    w = screenFrame.w / 4,
    h = screenFrame.h
  }
  
  positions.topQuarter = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w,
    h = screenFrame.h / 4
  }
  
  positions.bottomQuarter = {
    x = screenFrame.x,
    y = screenFrame.y + screenFrame.h * 3 / 4,
    w = screenFrame.w,
    h = screenFrame.h / 4
  }
  
  -- Corners
  positions.topLeft = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w / 2,
    h = screenFrame.h / 2
  }
  
  positions.topRight = {
    x = screenFrame.x + screenFrame.w / 2,
    y = screenFrame.y,
    w = screenFrame.w / 2,
    h = screenFrame.h / 2
  }
  
  positions.bottomLeft = {
    x = screenFrame.x,
    y = screenFrame.y + screenFrame.h / 2,
    w = screenFrame.w / 2,
    h = screenFrame.h / 2
  }
  
  positions.bottomRight = {
    x = screenFrame.x + screenFrame.w / 2,
    y = screenFrame.y + screenFrame.h / 2,
    w = screenFrame.w / 2,
    h = screenFrame.h / 2
  }
  
  -- Quarter corners
  positions.topLeftQuarter = {
    x = screenFrame.x,
    y = screenFrame.y,
    w = screenFrame.w / 4,
    h = screenFrame.h / 4
  }
  
  positions.topRightQuarter = {
    x = screenFrame.x + screenFrame.w * 3 / 4,
    y = screenFrame.y,
    w = screenFrame.w / 4,
    h = screenFrame.h / 4
  }
  
  positions.bottomLeftQuarter = {
    x = screenFrame.x,
    y = screenFrame.y + screenFrame.h * 3 / 4,
    w = screenFrame.w / 4,
    h = screenFrame.h / 4
  }
  
  positions.bottomRightQuarter = {
    x = screenFrame.x + screenFrame.w * 3 / 4,
    y = screenFrame.y + screenFrame.h * 3 / 4,
    w = screenFrame.w / 4,
    h = screenFrame.h / 4
  }

  self._cache.positions = positions
end

-- Get active window
function obj:_getWindow()
  local win = hs.window.frontmostWindow()
  if not win then return nil end
  
  self._cache.lastWindowId = win:id()
  return win
end

-- Apply window position
function obj:_applyPosition(win, newPosition)
  if not win or not newPosition then return end
  
  -- Skip if we're still within debounce period
  local now = hs.timer.secondsSinceEpoch()
  if now - self._cache.lastApplied < self.config.debounceDelay then
    return
  end
  self._cache.lastApplied = now
  
  -- Save the animation setting
  local prevDuration = hs.window.animationDuration
  hs.window.animationDuration = self.config.animationDuration
  
  -- Directly set frame
  win:setFrame(newPosition)
  
  -- Restore animation setting
  hs.window.animationDuration = prevDuration
end

-- Helper function for toggle behavior
function obj:_toggleOperation(win, opName, newPos)
  if not win then return false end
  
  local id = win:id()
  local currentFrame = win:frame()
  
  -- Check if this is a toggle (same operation on same window)
  if self._cache.lastOperation and 
     self._cache.lastOperation.id == id and
     self._cache.lastOperation.op == opName and
     self._cache.lastFrames[id] then
    
    -- Restore previous state
    self:_applyPosition(win, self._cache.lastFrames[id])
    
    -- Clear the operation to prevent immediate toggle back
    self._cache.lastOperation = nil
    return true
  end
  
  -- Store current frame before changing
  self._cache.lastFrames[id] = hs.geometry.copy(currentFrame)
  
  -- Set current operation
  self._cache.lastOperation = {
    id = id,
    op = opName
  }
  
  -- Apply the new position
  self:_applyPosition(win, newPos)
  return true
end

-- Simple directional movement that resizes and supports quarters
function obj:_moveDirection(direction)
  local win = self:_getWindow()
  if not win then return end
  
  local screen = win:screen()
  self:_precalculatePositions(screen)
  
  local screenFrame = self._cache.screenFrame
  if not screenFrame then return end
  
  local pos = nil
  local positions = self._cache.positions
  local currentFrame = win:frame()
  
  -- Check for combined key presses
  if direction == "left" and self._pressed.right then
    -- Left + Right = Full width
    pos = {
      x = screenFrame.x,
      y = currentFrame.y,
      w = screenFrame.w,
      h = currentFrame.h
    }
  elseif direction == "right" and self._pressed.left then
    -- Left + Right = Full width
    pos = {
      x = screenFrame.x,
      y = currentFrame.y,
      w = screenFrame.w,
      h = currentFrame.h
    }
  elseif direction == "up" and self._pressed.down then
    -- Up + Down = Full height
    pos = {
      x = currentFrame.x,
      y = screenFrame.y,
      w = currentFrame.w,
      h = screenFrame.h
    }
  elseif direction == "down" and self._pressed.up then
    -- Up + Down = Full height
    pos = {
      x = currentFrame.x,
      y = screenFrame.y,
      w = currentFrame.w,
      h = screenFrame.h
    }
  else
    -- Determine if window is already in one of our standard positions
    -- and select the next size if it is
    
    -- Check for left alignment
    if direction == "left" then
      if math.abs(currentFrame.x - screenFrame.x) < 5 then
        -- Already at left edge,
        local currentWidth = currentFrame.w / screenFrame.w  -- Get ratio of window width to screen width
        
        -- Define next size
        local nextSize
        if math.abs(currentWidth - 1/3) < 0.05 then
          nextSize = 1/4
        else
          nextSize = 1/2  -- Default to largest if not at standard size
        end
        
        -- Create position
        pos = {
          x = screenFrame.x,
          y = currentFrame.y,
          w = screenFrame.w * nextSize,
          h = currentFrame.h
        }
      else
        -- Not at left edge, move to left edge
        pos = {
          x = screenFrame.x,
          y = currentFrame.y,
          w = currentFrame.w,
          h = currentFrame.h
        }
      end
    elseif direction == "right" then
      if math.abs((currentFrame.x + currentFrame.w) - (screenFrame.x + screenFrame.w)) < 5 then
        -- Already at right edge
        local currentWidth = currentFrame.w / screenFrame.w
        
        -- Define next size
        local nextSize
        if math.abs(currentWidth - 1/3) < 0.05 then
          nextSize = 1/4
        else
          nextSize = 1/2  -- Default to largest if not at standard size
        end
        
        -- Create position
        pos = {
          x = screenFrame.x + screenFrame.w - (screenFrame.w * nextSize),
          y = currentFrame.y,
          w = screenFrame.w * nextSize,
          h = currentFrame.h
        }
      else
        -- Not at right edge, move to right edge
        pos = {
          x = screenFrame.x + screenFrame.w - currentFrame.w,
          y = currentFrame.y,
          w = currentFrame.w,
          h = currentFrame.h
        }
      end
    elseif direction == "up" then
      if math.abs(currentFrame.y - screenFrame.y) < 5 then
        -- Already at top edge
        local currentHeight = currentFrame.h / screenFrame.h
        
        -- Define next size
        local nextSize
        if math.abs(currentHeight - 1/3) < 0.05 then
          nextSize = 1/4
        else
          nextSize = 1/2  -- Default to largest if not at standard size
        end
        
        -- Create position
        pos = {
          x = currentFrame.x,
          y = screenFrame.y,
          w = currentFrame.w,
          h = screenFrame.h * nextSize
        }
      else
        -- Not at top edge, move to top edge
        pos = {
          x = currentFrame.x,
          y = screenFrame.y,
          w = currentFrame.w,
          h = currentFrame.h
        }
      end
    elseif direction == "down" then
      if math.abs((currentFrame.y + currentFrame.h) - (screenFrame.y + screenFrame.h)) < 5 then
        -- Already at bottom edge, cycle through heights
        local currentHeight = currentFrame.h / screenFrame.h
        
        -- Define next size
        local nextSize
        if math.abs(currentHeight - 1/3) < 0.05 then
          nextSize = 1/4
        else
          nextSize = 1/2  -- Default to largest if not at standard size
        end
        
        -- Create position
        pos = {
          x = currentFrame.x,
          y = screenFrame.y + screenFrame.h - (screenFrame.h * nextSize),
          w = currentFrame.w,
          h = screenFrame.h * nextSize
        }
      else
        -- Not at bottom edge, move to bottom edge
        pos = {
          x = currentFrame.x,
          y = screenFrame.y + screenFrame.h - currentFrame.h,
          w = currentFrame.w,
          h = currentFrame.h
        }
      end
    end
  end
  
  if pos then
    self:_applyPosition(win, pos)
  end
end

-- Handle fullscreen with toggle
function obj:_handleFullScreen()
  local win = self:_getWindow()
  if not win then return end
    
  local screen = win:screen()
  local screenFrame = screen:frame()
  
  local fullscreenPos = {
    x = 0,
    y = 0,
    w = screenFrame.w,
    h = screenFrame.h
  }
  
  -- Use toggle operation pattern
  self:_toggleOperation(win, "fullscreen", fullscreenPos)
end

-- Center window with toggle
function obj:centerWindow()
  local win = self:_getWindow()
  if not win then return end
  
  local screen = win:screen()
  local screenFrame = screen:frame()
  local f = win:frame()
  
  local centeredPos = {
    x = screenFrame.x + ((screenFrame.w - f.w) / 2),
    y = screenFrame.y + ((screenFrame.h - f.h) / 2),
    w = f.w,
    h = f.h
  }
  
  self:_toggleOperation(win, "center", centeredPos)
end

-- Maximize height with toggle
function obj:maximizeWindowHeight()
  local win = self:_getWindow()
  if not win then return end
  
  local screen = win:screen()
  local screenFrame = screen:frame()
  local f = win:frame()
  
  local maxHeightPos = {
    x = f.x,
    y = screenFrame.y,
    w = f.w,
    h = screenFrame.h
  }
  
  self:_toggleOperation(win, "maxHeight", maxHeightPos)
end

-- Maximize width with toggle
function obj:maximizeWindowWidth()
  local win = self:_getWindow()
  if not win then return end
  
  local screen = win:screen()
  local screenFrame = screen:frame()
  local f = win:frame()
  
  local maxWidthPos = {
    x = screenFrame.x,
    y = f.y,
    w = screenFrame.w,
    h = f.h
  }
  
  self:_toggleOperation(win, "maxWidth", maxWidthPos)
end

-- Move window to next/previous screen
function obj:moveToScreen(direction)
  local win = self:_getWindow()
  if not win then return end
  
  local screen = win:screen()
  local screenFrame = screen:frame()
  local f = win:frame()
  
  -- Get the next screen
  local nextScreen
  if direction == "next" then
    nextScreen = screen:next()
  else
    nextScreen = screen:previous()
  end
  
  if not nextScreen then return end
  
  -- Calculate relative position
  local nextScreenFrame = nextScreen:frame()
  local relX = (f.x - screenFrame.x) / screenFrame.w
  local relY = (f.y - screenFrame.y) / screenFrame.h
  local relW = f.w / screenFrame.w
  local relH = f.h / screenFrame.h
  
  -- Apply to new screen
  local newPos = {
    x = nextScreenFrame.x + (relX * nextScreenFrame.w),
    y = nextScreenFrame.y + (relY * nextScreenFrame.h),
    w = relW * nextScreenFrame.w,
    h = relH * nextScreenFrame.h
  }
  
  self:_applyPosition(win, newPos)
end

-- Bind hotkeys for window management
function obj:bindHotkeys(mapping)
  -- Standard directional controls
  local downFn = function()
    self._pressed.down = true
    self:_moveDirection("down")
  end
  
  local upFn = function()
    self._pressed.up = true
    self:_moveDirection("up")
  end
  
  local leftFn = function()
    self._pressed.left = true
    self:_moveDirection("left")
  end
  
  local rightFn = function()
    self._pressed.right = true
    self:_moveDirection("right")
  end
  
  -- Bind all the keys
  hs.hotkey.bind(mapping.down[1], mapping.down[2], downFn, function() self._pressed.down = false end)
  hs.hotkey.bind(mapping.up[1], mapping.up[2], upFn, function() self._pressed.up = false end)
  hs.hotkey.bind(mapping.left[1], mapping.left[2], leftFn, function() self._pressed.left = false end)
  hs.hotkey.bind(mapping.right[1], mapping.right[2], rightFn, function() self._pressed.right = false end)
  hs.hotkey.bind(mapping.fullscreen[1], mapping.fullscreen[2], function() self:_handleFullScreen() end)
  
  -- Optional additional hotkeys
  if mapping.center then
    hs.hotkey.bind(mapping.center[1], mapping.center[2], function() self:centerWindow() end)
  end
  
  if mapping.maximizeHeight then
    hs.hotkey.bind(mapping.maximizeHeight[1], mapping.maximizeHeight[2], function() self:maximizeWindowHeight() end)
  end
  
  if mapping.maximizeWidth then
    hs.hotkey.bind(mapping.maximizeWidth[1], mapping.maximizeWidth[2], function() self:maximizeWindowWidth() end)
  end
  
  if mapping.nextScreen then
    hs.hotkey.bind(mapping.nextScreen[1], mapping.nextScreen[2], function() self:moveToScreen("next") end)
  end
  
  if mapping.prevScreen then
    hs.hotkey.bind(mapping.prevScreen[1], mapping.prevScreen[2], function() self:moveToScreen("prev") end)
  end
end

-- Set configuration options
function obj:setConfig(config)
  if not config then return end
  
  for k, v in pairs(config) do
    if self.config[k] ~= nil then
      self.config[k] = v
    end
  end
end

function obj:init()
  hs.grid.setGrid(self.config.gridSize.w .. 'x' .. self.config.gridSize.h)
  hs.grid.MARGINX = 0
  hs.grid.MARGINY = 0
  hs.window.animationDuration = self.config.animationDuration
end

return obj