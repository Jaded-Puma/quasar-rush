EnemyBounceRenderer = lazy.class("EnemyBounceRenderer")

function EnemyBounceRenderer:constructor(entity)
    self.entity = entity

    self.animation = ModAnimate({334, 366}, 25, 2)
    self.animation_alt = ModAnimate({430, 462}, 35, 2)
end

function EnemyBounceRenderer:render()
    local camera = self.entity.game_logic.camera

    local pal = UTILITY.get_pal(self.entity)
    local anim = UTILITY.get_anim(self.entity)

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function() 
            anim:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys)
        end
    )
    lazy.tic.palette_reset()
end