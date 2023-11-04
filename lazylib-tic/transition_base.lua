local transition_color=0

TransitionBase = lazy.extend("TransitionBase", State)

function TransitionBase:constructor(state_manager, time_max, old_state, new_state)
  self.State = lazy.enum("INTRO","OUTRO")

  self.state_manager = state_manager

  self.old_state = old_state
  self.new_state = new_state

  self.state = self.State.INTRO

  self.time = 0
  self.time_max = time_max
  self.a = 0
end

function TransitionBase:update()
  self.a = lazy.math.bound(self.time / self.time_max, 0, 1)
  self.time = self.time + 1

  if self.a == 1 then
    if self.state == self.State.INTRO then
      self.state = self.State.OUTRO

      self.time = 0
      self.a = 0

      self.old_state:finish()
      self.new_state:start()
    elseif self.state == self.State.OUTRO then
      self.state_manager:continue(self.new_state)
    end
  end
end