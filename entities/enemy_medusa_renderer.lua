EnemyMedusaRenderer = lazy.class("EnemyMedusaRenderer")

function EnemyMedusaRenderer:constructor(entity)
    self.entity = entity

    self.animation = ModAnimate({322, 354}, 31, 2)
    self.animation_alt = ModAnimate({418, 450}, 21, 2)
end

function EnemyMedusaRenderer:render()
    local camera = self.entity.game_logic.camera

    local pal  = UTILITY.get_pal(self.entity)
    local anim = UTILITY.get_anim(self.entity)

    local dir = UTILITY.conver_direction_spr(self.entity.logic.spawn_dir)

    if self.entity.logic.wait > 0 then
        return
    end

    lazy.tic.set_palette_from_table(pal)
    local x = lazy.math.round(self.entity.x + camera.xs)
    local y = lazy.math.round(self.entity.y + camera.ys)
    self.entity.logic.flashing:render_function(
        function()
            anim:render(FRAME, x, y, nil, dir)
        end
    )
    lazy.tic.palette_reset()
end