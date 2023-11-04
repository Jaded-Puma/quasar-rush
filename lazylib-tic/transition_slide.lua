TransitionSlide = lazy.extend("TransitionSlide", TransitionBase)

local TRANSITION_COLOR = 0

function TransitionSlide:constructor(state_manager, time_max, old_state, new_state)
    TransitionSlide.super:initialize(self, state_manager, time_max, old_state, new_state)
end

function TransitionSlide:update()
    TransitionSlide.super.update(self)
end

function TransitionSlide:render() 
    if self.state == self.State.INTRO then
        self.old_state:render()
        self.old_state:overlay()
        local w = math.floor(0.5 + self.a * SCREEN.WIDTH)
        rect(0, 0, w, SCREEN.HEIGHT, TRANSITION_COLOR)
      elseif self.state == self.State.OUTRO then
        self.new_state:render()
        self.new_state:overlay()
        local x = math.floor(0.5 + self.a * SCREEN.WIDTH)
        local w = SCREEN.WIDTH - x
        rect(x, 0, w, SCREEN.HEIGHT, TRANSITION_COLOR)
      end
end
