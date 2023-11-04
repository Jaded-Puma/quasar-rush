EnemyKamikazeRenderer = lazy.class("EnemyKamikazeRenderer")

local AIM_COLOR = 4

function EnemyKamikazeRenderer:constructor(entity)
    self.entity = entity

    self.animation = ModAnimate({324, 356}, 22, 2)
    self.animation_alt = ModAnimate({420, 452}, 22, 2)
end

function EnemyKamikazeRenderer:render()
    local camera = self.entity.game_logic.camera
    local spaceship = self.entity.game_logic.spaceship

    local pal = UTILITY.get_pal(self.entity)
    local anim = UTILITY.get_anim(self.entity)

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            if self.entity.logic.state == self.entity.logic.STATES.FIND then
                anim:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys)
            elseif self.entity.logic.state == self.entity.logic.STATES.AIM then
                anim:renderFrame(1, self.entity.x + camera.xs, self.entity.y + camera.ys)
            elseif self.entity.logic.state == self.entity.logic.STATES.ATTACK then
                anim:renderFrame(2, self.entity.x + camera.xs, self.entity.y + camera.ys)
            end
        end
    )
    lazy.tic.palette_reset()

    if self.entity.logic.state == self.entity.logic.STATES.AIM then
        local normal = lazy.math.normal(self.entity.x + 8, self.entity.y + 8, spaceship.x + 8, spaceship.y + 8)

        local x0 = (self.entity.x + 8) + normal.x * 10
        local y0 = (self.entity.y + 8) + normal.y * 10
        local x1 = x0 + normal.x * 21
        local y1 = y0 + normal.y * 21
        line(x0 + camera.xs, y0 + camera.ys, x1 + camera.xs, y1 + camera.ys, AIM_COLOR)
    end
end