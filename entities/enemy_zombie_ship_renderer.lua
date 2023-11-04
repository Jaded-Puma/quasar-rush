EnemyZombieShipRenderer = lazy.class("EnemyZombieShipRenderer")

function EnemyZombieShipRenderer:constructor(entity)
    self.entity = entity

    self.animation = ModAnimate({320, 352}, 21, 2)
    self.animation_alt = ModAnimate({416, 448}, 51, 2)
end

function EnemyZombieShipRenderer:render()
    local size = self.entity.logic.size
    local camera = self.entity.game_logic.camera

    local pal = UTILITY.get_pal(self.entity)
    local anim = UTILITY.get_anim(self.entity)

    -- local pal = CONFIG.GLOBAL.PAL_MODE[self.entity.logic.pal_mode]
    -- if self.entity.logic.is_immune then
    --     pal = CONFIG.GLOBAL.IMMUNE_PAL
    -- end

    -- local anim = self.animation
    -- if self.entity.logic.use_alt_pal then
    --     anim = self.animation_alt
    -- end

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            anim:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys, size)
        end
    )
    lazy.tic.palette_reset()
end