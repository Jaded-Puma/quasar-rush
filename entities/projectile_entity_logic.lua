ProjectileEntityLogic = lazy.class("ProjectileEntityLogic")

local BUFFER = 24

function ProjectileEntityLogic:constructor(entity)
    self.entity = entity
end

function ProjectileEntityLogic:update(dt)
    self.update_func(self)

    if self.entity.x < -16 - BUFFER or self.entity.x > CONFIG.GAME.VIEWPORT.W + BUFFER then
        self.entity.delete = true
    end
    if self.entity.y < -self.entity.h or self.entity.y > CONFIG.GAME.VIEWPORT.H + BUFFER then
        self.entity.delete = true
    end
end