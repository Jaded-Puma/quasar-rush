EnemySeekerRenderer = lazy.class("EnemySeekerRenderer")

local ANIM_TIME_1 = 21

function EnemySeekerRenderer:constructor(entity)
    self.entity = entity

    self.animation_side_l = ModAnimate({292, 292, 294}, ANIM_TIME_1, 1)
    self.animation_side_r = ModAnimate({294, 294, 292}, ANIM_TIME_1, 1)
    self.animation_main = ModAnimate({293}, ANIM_TIME_1, 1)

    self.animation_side_l_alt = ModAnimate({308, 308, 310}, ANIM_TIME_1, 1)
    self.animation_side_r_alt = ModAnimate({310, 310, 308}, ANIM_TIME_1, 1)
    self.animation_main_alt = ModAnimate({309}, ANIM_TIME_1, 1)
end

function EnemySeekerRenderer:render()
    local camera = self.entity.game_logic.camera
    
    local pal = UTILITY.get_pal(self.entity)

    local anim_side_l = self.animation_side_l
    local anim_side_r = self.animation_side_r
    local anim_main = self.animation_main
    if self.entity.logic.use_alt_pal then
        anim_side_l = self.animation_side_l_alt
        anim_side_r = self.animation_side_r_alt
        anim_main = self.animation_main_alt

    end

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            local x = self.entity.x + camera.xs
            local y = self.entity.y + camera.ys

            anim_side_l:render(FRAME, x, y)
            anim_main:renderFrame(1, x + 8, y)
            anim_side_r:render(FRAME, x + 16, y, nil, 1)

        end
    )
    lazy.tic.palette_reset()
end