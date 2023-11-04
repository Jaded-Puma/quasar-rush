EnemyShooterRenderer = lazy.class("EnemyShooterRenderer")

function EnemyShooterRenderer:constructor(entity)
    self.entity = entity

    self.animation = ModAnimate({326, 358}, 24, 2)
    self.animation_alt = ModAnimate({422, 454}, 24, 2)

    self.mode1_id = 500
    self.mode2_id = 484
end

function EnemyShooterRenderer:render()
    local camera = self.entity.game_logic.camera

    local pal = UTILITY.get_pal(self.entity)
    local anim = UTILITY.get_anim(self.entity)

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            if self.entity.logic.state == self.entity.logic.STATES.MOVE then
                anim:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys)
            else
                anim:renderFrame(2, self.entity.x + camera.xs, self.entity.y + camera.ys)
            end


            if self.entity.logic.mode == 1 then
                spr(
                    self.mode1_id,
                    self.entity.x + camera.xs, self.entity.y + 8 + camera.ys,
                    0, 1, 0, 0,
                    2, 1
                )
            elseif self.entity.logic.mode == 2 then
                spr(
                    self.mode2_id,
                    self.entity.x + camera.xs, self.entity.y + 8 + camera.ys,
                    0, 1, 0, 0,
                    2, 1
                )
            end
        end
    )
    lazy.tic.palette_reset()
end