ProjectileEntity = lazy.extend("ProjectileEntity", Entity)

function ProjectileEntity:constructor(source, game_logic, x, y, normal, speed, acc, update_func, mod_animate)
    self.source = source
    self.game_logic = game_logic

    self.logic = ProjectileEntityLogic(self)
    self.renderer = ProjectileEntityRenderer(self)

    self.animate = mod_animate

    self.logic.normal = normal
    self.logic.speed = speed
    self.logic.acc = acc

    self.logic.update_func = update_func or (function (self)
        self.entity.x = self.entity.x + self.speed * self.normal.x
        self.entity.y = self.entity.y + self.speed * self.normal.y
    end)


    self.logic.base_x = x
    self.logic.base_y = y
    self.logic.angle = 0

    ProjectileEntity.super:initialize(
        self,
        x, y,
        4, 4
    )
end

function ProjectileEntity:update(dt)
    self.logic:update(dt)
end

function ProjectileEntity:render()
    self.renderer:render()
end