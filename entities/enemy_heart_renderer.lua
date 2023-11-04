EnemyHeartRenderer = lazy.class("EnemyHeartRenderer")

local PI2 = math.pi * 2

function EnemyHeartRenderer:constructor(entity)
    self.entity = entity

    self.spr_id_mouth = 72
    self.spr_id_eyes = 76

    self.spr_id_eye_back = 118
    self.spr_id_iris = 119

    self.body_parts = 12
    self.spr_id_list_body = {490, 491, 492, 493, 494, 495}

    self.body_small_id = 488

    self.blink_timeout_max = 35
    self.blink_timeout = 0

    self.anim_black_hole = ModAnimate({87, 103}, 12)

    self.blink_frame = 180

    self.strench = PI2 / 1
    self.a = 0
    self.t = 0

    self.eyes = {
        lazy.util.position(13, 3),
        lazy.util.position(23, 8),
        lazy.util.position(25, 15),
        lazy.util.position(19, 22),
        lazy.util.position(11, 21),
        lazy.util.position(5, 19),
        lazy.util.position(8, 13),
        lazy.util.position(2, 11),
        lazy.util.position(5, 6),
    }

end

function EnemyHeartRenderer:render()
    local camera = self.entity.game_logic.camera

    local STATES = self.entity.logic.STATES
    local state = self.entity.logic.state

    if FRAME % self.blink_frame == 0 then
        self.blink_timeout = self.blink_timeout_max

        self.blink_frame = math.random(180, 500)
    end
    if self.blink_timeout > 0 then
        self.blink_timeout  = self.blink_timeout - 1
    end

    self.t = self.t + 0.0007

    local pal  = CONFIG.GLOBAL.PAL_DEFAULT
    if state == STATES.TRANS_IN 
    or state == STATES.TRANS_OUT
    then
        pal = CONFIG.ENEMY.HEART.PAL_INTRO
    end
    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            -- local pal = CONFIG.GLOBAL.PAL_DEFAULT
            if state == STATES.TRANS_IN then
                -- print("TRANS_IN", 1, 1)

            end

            -- quasar
            spr(
                128,
                CONFIG.GAME.VIEWPORT.W - 20 - 16, 8 * 7 - 1,
                0, 1, 0, 0,
                4, 4
            )

            -- body part fix
            spr(
                495,
                self.entity.x + 24 + 4, self.entity.y + 16,
                0
            )
            -- draw body
            for i = 0, self.body_parts do
                for i_body, id in ipairs(self.spr_id_list_body) do
                    local angle_offset = i * PI2 / 4
                    local offset = 2 * math.sin(angle_offset + PI2*self.t * self.strench)
                    local x = self.entity.x - 4 + (i * 8) + (i_body - 1) * 8 + offset
                    local y = self.entity.y + (i - 1) * -8

                    if not (i == 0 and i_body == 1) then
                        spr(
                            id,
                            x, y,
                            0
                        )
                    end

                    
                end
            end

            -- draw small body
            for i = 0, 8 do
                -- self.body_small_id
                local x = CONFIG.GAME.VIEWPORT.W - 20 + math.sin(i * PI2 / 4 + PI2 * FRAME * 0.0045 )
                local y = i * 8

                spr(
                            self.body_small_id,
                            x, y,
                            0
                        )
            end

            if state == STATES.IDLE
            or state == STATES.TRANS_IN
            or state == STATES.TRANS_OUT
            then
                for _, eye in ipairs(self.eyes) do
                    local x = self.entity.x + eye.x
                    local y = self.entity.y + eye.y

                    spr(
                        self.spr_id_eye_back,
                        x, y,
                        0
                    )
                    local offset = self.entity.game_logic.spaceship.x / (CONFIG.GAME.VIEWPORT.W - 16) * 4

                    spr(
                        self.spr_id_iris,
                        x + offset - 1, y + 2,
                        0
                    )

                    if self.blink_timeout > 0 then
                        local offset = (x * y) % 15

                        local a = (self.blink_timeout - offset) / (self.blink_timeout_max / 2)
                        a = lazy.math.bound(a, 0, 1)
                        local h = 5 * a

                        rect(x, y, 5, h, 6)
                    end
                end

                spr(
                    self.spr_id_eyes,
                    self.entity.x, self.entity.y,
                    0, 1, 0, 0,
                    4, 4
                )
            elseif state == STATES.ATTACK 
            or state == STATES.ANTICIPATION
            or state == STATES.COOLDOWN
            then
                spr(
                    self.spr_id_mouth,
                    self.entity.x, self.entity.y,
                    0, 1, 0, 0,
                    4, 4
                )

                self.anim_black_hole:render(FRAME, self.entity.x + 11, self.entity.y + 12)
            end
        end
    )
    lazy.tic.palette_reset()
end