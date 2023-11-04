ControlBallEntity = lazy.extend("ControlBallEntity", Entity)

function ControlBallEntity:constructor(game_logic, x, y, w, h)
    self.game_logic = game_logic

    self.logic  = ControlBallEntityLogic(self)
    self.renderer = ControlBallEntityRenderer(self)

    ControlBallEntity.super:initialize(
        self,
        x, y,
        w, h
    )

    -- self.speed = CONFIG.SPACESHIP.SPEED
end

function ControlBallEntity:update(dt)
    self.logic:update(dt)
end

function ControlBallEntity:render()
    self.renderer:render()
end