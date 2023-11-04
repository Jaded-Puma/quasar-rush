SpaceshipEntity = lazy.extend("SpaceshipEntity", Entity)

function SpaceshipEntity:constructor(game_logic, x, y, w, h)
    self.logic = SpaceshipEntityLogic(self)
    self.renderer = SpaceshipEntityRenderer(self)

    self.game_logic = game_logic

    SpaceshipEntity.super:initialize(
        self,
        x, y,
        w, h
    )
end

function SpaceshipEntity:update(dt)
    self.logic:update(dt)
end

function SpaceshipEntity:render()
    self.renderer:render()
end