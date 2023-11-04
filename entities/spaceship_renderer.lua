SpaceshipEntityRenderer = lazy.class("SpaceshipEntityRenderer")

function SpaceshipEntityRenderer:constructor(entity)
    self.entity = entity

    self.id = 256
    self.y = 96
    self.sprw = 2
    self.sprh = 2

    self.turning = 0
end

function SpaceshipEntityRenderer:render()
    local camera = self.entity.game_logic.camera

    self.entity.logic.flashing:render_function(
        function()
            spr(
                self.id,
                self.entity.x + camera.xs, self.entity.y + camera.ys,
                0, 1, 0, 0,
                self.sprw, self.sprh
            )
        end
    )
end

function SpaceshipEntityRenderer:setTurning(turning)
    self.turning = turning
end