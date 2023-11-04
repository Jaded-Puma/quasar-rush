ProjectileEntityRenderer = lazy.class("ProjectileEntityRenderer")

function ProjectileEntityRenderer:constructor(entity)
    self.entity = entity
end

function ProjectileEntityRenderer:render()
    local camera = self.entity.game_logic.camera

    self.entity.animate:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys)
end