-- helper state to allow state transitions

-- Transition State class
TransitionState = lazy.extend("TransitionState", State)

function TransitionState.constructor(self, manager, old_state, new_state, Transition, time_max)
  self.manager = manager
  self.transition = Transition(time_max, old_state, new_state)
end

function TransitionState:update()
  self.transition:update()
  
  if not self.transition.transitioning then
    self.manager:replace(self.transition.new_state, false)
  end
end

function TransitionState:render()
  self.transition:render()
end

function TransitionState:overlay()
  self.transition:overlay()
end

function TransitionState:scanline(scanline)
  self.transition:scanline(scanline)
end
