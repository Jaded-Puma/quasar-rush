EnemyOrganicRenderer = lazy.class("EnemyOrganicRenderer")

function EnemyOrganicRenderer:constructor(entity)
    self.entity = entity

    self.animation_head = ModAnimate({330, 332}, 140, 2)
    self.animation_body = ModAnimate({362, 364}, 45, 2)

    self.animation_head_alt = ModAnimate({426, 428}, 120, 2)
    self.animation_body_alt = ModAnimate({458, 460}, 25, 2)
end

function EnemyOrganicRenderer:render()
    local camera = self.entity.game_logic.camera
    
    local pal = UTILITY.get_pal(self.entity)
    local dir = UTILITY.conver_direction_spr(self.entity.logic.spawn_dir)

    local anim_head = self.animation_head
    local anim_body = self.animation_body
    if self.entity.logic.use_alt_pal then
        anim_head = self.animation_head_alt
        anim_body = self.animation_body_alt
    end

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            if self.entity.logic.state == self.entity.logic.STATES.MOVE then
                anim_head:renderFrame(1, self.entity.x + camera.xs, self.entity.y + camera.ys, nil, dir)
            else
                anim_head:renderFrame(2, self.entity.x + camera.xs, self.entity.y + camera.ys, nil, dir)
            end
            -- anim_head:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys, nil, dir)
            anim_body:render(FRAME, self.entity.x + camera.xs, self.entity.y + camera.ys + 16, nil, dir)
        end
    )
    lazy.tic.palette_reset()
end