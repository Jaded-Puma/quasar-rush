-- Rendering logic for "level"

StateLevelRenderer = lazy.class("StateLevelRenderer")

function StateLevelRenderer:constructor(logic)
    self.logic = logic

    self.starfield_bg = self:_create_startfield(320)
    self.starfield_mg = self:_create_startfield(200)
    self.starfield_fg = self:_create_startfield(130)

    self.cursor_id = 290

    self.flame_animation = ModAnimate({287, 286, 271, 270}, 6)

    self.quasar_pos = lazy.util.position(CONFIG.GAME.VIEWPORT.W - 20 - 16, 8 * 7 - 1)
    self.quasar_anim = ModAnimate({128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 192, 128, 192, 128, 192}, 7, 4)

    -- UI
    -- TODO replace with box function {}
    self.hp_bar_pos = lazy.util.position(25*8+4, 1*8+1)
    self.hp_bar_dim = lazy.util.dimension(32, 5)

    self.exp_bar_pos = lazy.util.position(25*8+4, 3*8+1)
    self.exp_bar_dim = lazy.util.dimension(32, 5)

    self.num_level_start_pos = lazy.util.position(26*8, 5*8)
    self.num_wave_start_pos = lazy.util.position(26*8, 8*8)

    self.wave_box_pos = lazy.util.position(26*8, 9*8)
    self.wave_box_dim = lazy.util.dimension(16, 32)

    self.arrow_animation = ModAnimate({299, 315}, 25)

    self.upgrade_prompt_color_toggle = true
    self.wave_text_color_toggle = true
    self.gameover_text_color_toggle = true
end

function StateLevelRenderer:render()
    self:_draw_startfield()

    self.logic.particle_handler_bg:render()

    -- spaceship
    if self.logic.state ~= self.logic.STATES.TRANS_GAMEOVER 
    and self.logic.state ~= self.logic.STATES.GAMEOVER then
        self.logic.spaceship:render()
        self.flame_animation:render(
            FRAME, 
            self.logic.control_ball.x + 4 + self.logic.camera.xs,
            self.logic.spaceship.y + 16 - 2 + self.logic.camera.ys
        )
    end

    -- ! deprecated 
    -- bullets
    for _, proj in ipairs(self.logic.projectiles) do
        spr(
            self.logic.weapon_id,
            proj.x, proj.y,
            0, 1, 0, 0,
            1, 1
        )
    end

    -- ! deprecated 
    for _, enemy  in ipairs(self.logic.enemies) do
        spr(
            self.logic.enemy_id,
            enemy.x, enemy.y,
            0, 1, 0, 0,
            2, 2
        )
    end

    -- entity rendering
    
    self.logic.enemy_handler:sort(
        function(a, b)
            return a.render_prio < b.render_prio
        end
    )
    self.logic.enemy_handler:render()
    self.logic.exp_handler:render()
    self.logic.sfx_handler:render()
    self.logic.particle_handler:render()

    self.logic.projectile_handler:render()
    self.logic.enemy_projectile_handler:render()

    if DEMO_STRING ~= nil then
        print(DEMO_STRING, 1, CONFIG.GAME.VIEWPORT.H - 7, 15)
    end

    self:_draw_gameover()

    -- debug code
    self:_debug()
end

function StateLevelRenderer:overlay()
    self:_draw_wave_text()

    self:_draw_ui()

    -- control ball render
    self.logic.control_ball:render()

    -- cursor
    if self.logic.control_ball.logic.tap_hold 
    and self.logic.state == self.logic.STATES.GAME then
        local x = lazy.math.bound(CURSOR.x - 8, 0, CONFIG.GAME.VIEWPORT.W - 8 - 8)

        spr(
            self.cursor_id,
            x, self.logic.control_ball.y,
            0, 1, 0, 0,
            2, 2
        )
    end

    if not self.logic.control_ball.logic.tap_hold and self.logic.state == self.logic.STATES.GAME then
        local x = self.logic.control_ball.x + 8 - 4
        local y = self.logic.control_ball.y - 2 + 2 * math.sin(FRAME / 15)
        self.arrow_animation:render(FRAME, x, y)
    end 

    self:_draw_updrade_text()
end

function StateLevelRenderer:_debug()
    if not DEBUG_MODE then return end

    if self.logic.debug_report_timeout > 0 then
        local x = 2
        local y = CONFIG.GAME.VIEWPORT.H - 8
        print(self.logic.debug_report, x+1, y+1, 2)
        print(self.logic.debug_report, x, y, 15)
    end

    -- 
    

    local fps = FPS:getValue()
    local frame = lazy.math.round((fps / 60), 0.1)

    if DEBUG_DISPLAY then
        local a  = 0.1
        local round = lazy.math.round

        print("Entity #: "..round(self.logic.entity_count_avg, a).." : "..self.logic.entity_count, 1, 1, 15)
        print("Projectile #: "..round(self.logic.projectile_count_avg, a).." : "..self.logic.projectile_count, 1, 1 + 8, 15)
        print("Particle #: "..round(self.logic.particle_count_avg, a).." : ".. self.logic.particle_count, 1, 1 + 8 * 2, 15)
        print("FPS #: "..round(self.logic.fps_avg).." : "..fps.. 
            " FRM: "..round(self.logic.frame_avg, 0.1).." : "..frame, 1, 1 + 8 * 3, 15)
        print("MEM KB: "..round(collectgarbage("count")).." | GC STEP: "..GC_STEP, 1, 1 + 8 * 4, 15)
    end

    local c = 3
    if fps > 58 then
        c = 11
    elseif fps > 56 then
        c = 9
    end

    local s = 6
    
    if DEBUG_SHOW_COLOR_FPS then
        rect(0, 0, s, s, c)
        rectb(0, 0, s, s, 0)
    end

    if DEBUG_WAVE_DISPLAY then
        local wave_time = self.logic.current_wave_time
        local wave_time_sec = lazy.math.round(wave_time / 60, 0.01)
        print("W.TIME " .. wave_time_sec .. ":" .. wave_time, 1, 1)

        local COMPLEXITY_MAVG = lazy.math.round(self.logic.METRICS.MAVG.CAVG, 0.01)
        print("COMPL " .. COMPLEXITY_MAVG, 1, 1+8)
    end

    
    if DEBUG_BOUNDINGBOX then
        lazy.tic.draw_box_class(self.logic.spaceship, 15, CONFIG.GLOBAL.KEY_HITBOX)

        self.logic.enemy_handler:loop(
            function(enemy)
                lazy.tic.draw_box_class(enemy, 15, CONFIG.GLOBAL.KEY_HITBOX)
            end
        )

        self.logic.projectile_handler:loop(
            function(proj)
                lazy.tic.draw_box_class(proj, 15, CONFIG.GLOBAL.KEY_HITBOX)
            end
        )

        self.logic.enemy_projectile_handler:loop(
            function(proj)
                lazy.tic.draw_box_class(proj, 15, CONFIG.GLOBAL.KEY_HITBOX)
            end
        )
    end
end

function StateLevelRenderer:_draw_digits(x, y, num, length)
    local digit_count = 0
    if num > 0 then
        digit_count = string.len(tostring(num))
    else
        digit_count = length or string.len(tostring(num))
    end

    if num < 0 then
        local char = 1

        if num == -1 then
            char = 11
        elseif num == -2 then
            char = 12
        end

        local digit_sid = DATA.SPR_NUM[char]

        for i = digit_count, 1, -1 do
            spr(
                digit_sid,
                x + 8 * (i - 1), y,
                0, 1, 0, 0,
                1, 1
            )
        end
    else
        for i = digit_count, 1, -1 do
            local get_digit = num % 10
            num = math.floor(num / 10)
            local digit_sid = DATA.SPR_NUM[get_digit + 1]
    
            spr(
                digit_sid,
                x + 8 * (i - 1), y,
                0, 1, 0, 0,
                1, 1
            )
        end
    end
    
end

function StateLevelRenderer:_draw_startfield()
    self.starfield_bg:_update_warp()
    self.starfield_mg:_update_warp()
    self.starfield_fg:_update_warp()
    

    self.starfield_bg:_draw_map(self.logic.camera, 30, 0, 90, 0)
    self.starfield_mg:_draw_map(self.logic.camera, 150, 0, 150, 0)

    -- spr(128, 148, 30, 0, 2, 0, 0, 4, 4)
    lazy.tic.set_palette_from_table(CONFIG.GLOBAL.QUASAR_PAL)
    if self.logic.quasar_mode then
        self.quasar_anim:render(FRAME, self.quasar_pos.x, self.quasar_pos.y, nil)

        if FRAME % 12 == 0 then
            local cx = self.quasar_pos.x + 16
            local cy = self.quasar_pos.y + 16
            PARTICLE_FACTORY.quasar(self.logic.particle_handler_bg, cx, cy)
        end
    end
    lazy.tic.palette_reset()

    self.starfield_fg:_draw_map(self.logic.camera, 60, 0, 120, 0)

    -- ? quasar????
    -- spr(128, 148, 30, 0, 2, 0, 0, 4, 4)
    -- spr(id, x, y, [colorkey=-1], [scale=1], [flip=0], [rotate=0], [w=1], [h=1])

    

    -- self.starfield_fg.y = lazy.math.lerp(self.starfield_fg.a, 0, SCREEN.HEIGHT)
    -- map(60, 0, 30, 17, self.starfield_fg.x, self.starfield_fg.y - SCREEN.HEIGHT, 0)
    -- map(60, 0, 30, 17, self.starfield_fg.x, self.starfield_fg.y, 0)


    -- star field background
    -- local x = self.logic.camera.xs
    -- local y = lazy.math.round(self.starfield_1_x_scroll) + self.logic.camera.ys
    -- map(30, 0, 30, 17, x, y + -SCREEN.HEIGHT)
    -- map(30, 0, 30, 17, x, y)

    -- x = self.logic.camera.xs
    -- y = lazy.math.round(self.starfield_2_x_scroll) + self.logic.camera.ys
    -- map(60, 0, 30, 17, x, y + -SCREEN.HEIGHT, 0)
    -- map(60, 0, 30, 17, x, y, 0)

    -- -- starfield update
    -- local a = self.logic.spaceship.logic.level / CONFIG.SPACESHIP.MAX_LEVEL
    -- local speed_mod = 1 + STARFIELD_LEVEL_MUL * a


    -- self.starfield_1_x_scroll = (self.starfield_1_x_scroll + self.starfield_1_x_scroll_speed * speed_mod) % SCREEN.HEIGHT
    -- self.starfield_2_x_scroll = (self.starfield_2_x_scroll + self.starfield_2_x_scroll_speed * speed_mod) % SCREEN.HEIGHT
end

function StateLevelRenderer:_draw_ui()
    -- UI
    -- ui screen
    local pal = CONFIG.UI.UI_DEFAULT_PAL
    if self.logic.spaceship.logic.flashing:is_flashing() then
        pal = CONFIG.UI.UI_HURT_PAL
    elseif self.logic.boss_mode then
        pal = CONFIG.UI.UI_BOSS_PAL
    end

    map(0, 0, 30, 17, 0, 0, 0)
    lazy.tic.set_palette_from_table(pal)
    map(30, 17, 30, 17, 0, 0, 0)
    lazy.tic.palette_reset()

    -- hp bar
    local hp_w = math.ceil((1 - self.logic.spaceship.logic:getHpPercent()) * self.hp_bar_dim.w)
    rect(self.hp_bar_pos.x, self.hp_bar_pos.y, hp_w, self.hp_bar_dim.h, 1)
    -- exp bar
    local exp_w = math.ceil( (1 - self.logic.spaceship.logic:getExpPercent())^2 * self.exp_bar_dim.w)
    rect(self.exp_bar_pos.x, self.exp_bar_pos.y, exp_w, self.exp_bar_dim.h, 1)

    -- level number bar
    local level = self.logic.spaceship.logic.level
    if level == CONFIG.SPACESHIP.MAX_LEVEL then
        level = -2
    end
    self:_draw_digits(self.num_level_start_pos.x, self.num_level_start_pos.y, level, 2)

    -- wave box ui
    lazy.tic.set_palette_from_table(CONFIG.UI.WAVE_NUM_PAL)
    local wave = (self.logic.quasar_mode and -1 or self.logic.wave)
    self:_draw_digits(self.num_wave_start_pos.x, self.num_wave_start_pos.y, wave, 2)
    lazy.tic.palette_reset()
    -- wave marker
    local x = self.wave_box_pos.x + self.wave_box_dim.w 
    local y = self.wave_box_pos.y + lazy.math.round((self.wave_box_dim.h - 8) * (1 - self.logic.wave_percent))
    spr(
        46,
        x - 1, y,
        0, 1, 0, 0,
        1, 1
    )

    -- 25 15
    -- score
    lazy.tic.set_palette_from_table(CONFIG.UI.SCORE_NUM_PAL)
    self:_draw_digits(25 * 8 + 1, 15 * 8 - 1, self.logic.score)
    lazy.tic.palette_reset()

    lazy.tic.set_palette_from_table(CONFIG.UI.SCORE_TOP_NUM_PAL)
    self:_draw_digits(25 * 8 + 1, 16 * 8 - 1, self.logic.score_top)
    lazy.tic.palette_reset()
end

function StateLevelRenderer:_draw_wave_text()
    if self.logic.wave_text_timer > 0 
    and self.logic.state == self.logic.STATES.GAME 
    and self.logic.wave > 0
    then
        if FRAME % 15 == 0 then
            self.wave_text_color_toggle = not self.wave_text_color_toggle
        end

        local colorbg = 2
        local color1 = 13
        local color2 = 15
        if self.logic.quasar_mode then
            color1 = 10
            color2 = 15
        end
        -- quasar rush colors are different

        -- TODO FIXME timming issue, displays wrong text on single frame
        local wave_text = lazy.util.fif(self.logic.quasar_mode, "Rush", "Wave "..self.logic.wave)

        local t_width = print(wave_text, -32, -32, 15, false, 4, false)
        local t_heigh = 6 * 4 - 1

        local x = CONFIG.GAME.VIEWPORT.W / 2 - t_width / 2
        local y = CONFIG.GAME.VIEWPORT.H / 2 - t_heigh / 2

        print(wave_text, x + 2, y + 2, colorbg, false, 4, false)

        if self.wave_text_color_toggle then
            print(wave_text, x, y, color1, false, 4, false)
        else
            print(wave_text, x, y, color2, false, 4, false)
        end
    end
end

function StateLevelRenderer:_draw_updrade_text()
    if self.logic.upgrade_prompt.time ~= 0 then
        local colorbg = 2
        local color1 = 3
        local color2 = 15

        local x = 2
        local y = CONFIG.GAME.VIEWPORT.H + 8 - 3

        if FRAME % 5 == 0 then
            self.upgrade_prompt_color_toggle = not self.upgrade_prompt_color_toggle
        end

        print(
            self.logic.upgrade_prompt.text,
            x+1, y+1,
            colorbg,
            false,
            1,
            false
        )

        if self.upgrade_prompt_color_toggle then
            print(
                self.logic.upgrade_prompt.text,
                x, y,
                color1,
                false,
                1,
                false
            )
        else
            print(
                self.logic.upgrade_prompt.text,
                x, y,
                color2,
                false,
                1,
                false
            )
        end
    end
end

function StateLevelRenderer:_draw_gameover()
    if self.logic.state == self.logic.STATES.GAMEOVER then
        local color1 = 9
        local color2 = 15

        local color3 = 14
        local color4 = 6

        local colorbg1 = 3
        local colorbg2 = 5
        local colorbg3 = 2
        local size = 3
        local inc = 1

        local width = print("GAME OVER", -100, -100, color1, false, size)

        local x = CONFIG.GAME.VIEWPORT.W / 2 - width / 2
        local y = CONFIG.GAME.VIEWPORT.H / 2 - (size * 6 / 2 - 1)


        print("GAME OVER", x + inc * 3, y + inc * 3, colorbg3, false, size)
        print("GAME OVER", x + inc * 2, y + inc * 2, colorbg2, false, size)
        print("GAME OVER", x + inc * 1, y + inc * 1, colorbg1, false, size)

        if FRAME % 20 == 0 then
            self.gameover_text_color_toggle = not self.gameover_text_color_toggle
        end

        if self.gameover_text_color_toggle then
            print("GAME OVER", x, y, color1, false, size)
        else
            print("GAME OVER", x, y, color2, false, size)
        end

        if self.logic.has_new_score then
            local msg = "NEW HSCORE"
            local size = 2

            y = y + 21
            local width = print(msg, -100, -100, color1, false, size)
            x = CONFIG.GAME.VIEWPORT.W / 2 - width / 2

            print(msg, x+1, y, color4, false, size)
            print(msg, x, y+1, color4, false, size)
            print(msg, x-1, y, color4, false, size)
            print(msg, x, y-1, color4, false, size)

            print(msg, x, y, color3, false, size)
        end

    end
end

function StateLevelRenderer:_create_startfield(warp_time_max)
    local startfield = {}

    startfield.x = 0
    startfield.x_top = 0
    startfield.y = 0
    startfield.warp_time_max = warp_time_max
    startfield.warp_time = warp_time_max
    startfield.a = 1

    startfield._update_warp = function(self)
        self.warp_time = self.warp_time - 1

        self.a = 1 - self.warp_time / self.warp_time_max

        self.y = lazy.math.lerp(self.a, 0, SCREEN.HEIGHT)

        if self.warp_time == 0 then
            self.warp_time = self.warp_time_max
            self.a = 0
            startfield.x = startfield.x_top
            startfield.x_top = -math.random(0, SCREEN.WIDTH)
        end
    end

    startfield._draw_map = function(self, camera, mx0, my0, mx1, my1)
        self.y = lazy.math.lerp(self.a, 0, SCREEN.HEIGHT)

        map(mx0, my0, 30, 17, self.x + camera.xs, self.y + camera.ys, 0)
        map(mx1, my1, 30, 17, self.x + camera.xs + SCREEN.WIDTH, self.y + camera.ys, 0)

        map(mx0, my0, 30, 17, self.x_top + camera.xs, self.y + camera.ys - SCREEN.HEIGHT, 0)
        map(mx1, my1, 30, 17, self.x_top + camera.xs + SCREEN.WIDTH, self.y + camera.ys - SCREEN.HEIGHT, 0)
    end

    return startfield
end