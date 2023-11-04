-- Class that handles "State"

StateManager = lazy.class("StateManager")

function StateManager:constructor(start_state)
  self.state = start_state
  self.state:start()
end

function StateManager:next(state)
  -- old state
  self.state:finish()
  -- new state
  self.state = state
  self.state:start()
end

function StateManager:continue(state)
  self.state = state
end

function StateManager:update(dt)
  self.state:update(dt)
end

function StateManager:render()
 self.state:render()
end

function StateManager:scanline(scanline)
  self.state:scanline(scanline)
end

function StateManager:overlay()
  self.state:overlay()
end




