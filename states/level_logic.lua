-- State to handle logic on the "level"

StateLevelLogic = lazy.class("StateLevelLogic")

local STATE_GAMEOVER_TIMEOUT_MAX = 60 * 4

local PARTICLE_LIMIT = 500

function StateLevelLogic:constructor(base_state)
    self.base_state = base_state

    self.STATES = lazy.enum(
        "SHIP_SELECT",
        "INTRO",
        "GAME",
        "NEW_WAVE",
        "TRANS_GAMEOVER",
        "GAMEOVER"
    )
    self.state = self.STATES.INTRO
    self.state_timeout = 0

    self.camera = Camera(0, 0, CONFIG.GAME.VIEWPORT.W, CONFIG.GAME.VIEWPORT.H)

    self.play_music = true
    self.current_track_id = -1

    self.score = 0
    self.score_top = pmem(0)

    self.current_wave_time = 0
    self.wave_time_max = 0
    self.wave = 0
    self.current_wave = nil
    self.wave_percent = 0

    self.quasar_mode = false
    self.quasar_level = -1
    self.boss_mode = false

    self.hard_mode = DEBUG_ENABLE_HARDMODE

    self.wave_text_timer = CONFIG.LEVEL.WAVE_TEXT_TIMER_MAX

    self.has_new_score = false

    -- control entity
    self.control_ball = ControlBallEntity(
        self,
        CONFIG.GAME.VIEWPORT.W / 2 - 8, CONFIG.CONTROLBALL.Y,
        16, 16
    )

    -- spaceship entity
    self.spaceship = SpaceshipEntity(self, self.control_ball.x, CONFIG.GAME.VIEWPORT.H, 16, 16)
    local hb = CONFIG.SPACESHIP.HITBOX
    self.spaceship:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hb.X, hb.Y, hb.W, hb.H)

    -- intro control
    self.intro_time_max = 12 -- 120
    self.intro_time = self.intro_time_max

    --  ! depricated
    self.projectiles = {}
    self.weapon_id = 269
    self.weapon_recharge_total = 40
    self.weapon_recharge_current = 1

    self.projectiles_ids = {269, 285}
    self.projectiles_ids_mode3 = {266, 282}
    self.frame_time = 3

    self.projectile_spaceship_anim_base = ModAnimate({269, 285}, 3)
    self.projectile_spaceship_anim_sin = ModAnimate({266, 282}, 4)

    self.projectile_enemy_shooter_anim = ModAnimate({268, 284}, 3)
    self.projectile_enemy_organic_anim = ModAnimate({267, 283}, 5)

    self.projectile_spaceship_anim_rocket = ModAnimate({265, 281}, 5)

    self.enemy_projectile_ids = {268, 284}
    self.enemy_organic_projectile_ids = {267, 283}
    self.projectile_speed = 3.5

    self.projectile_handler = EntityHandler()
    self.enemy_projectile_handler = EntityHandler()

    -- ! depricated
    self.temp_enemy_timer = 0
    self.temp_enemy_timer_max = 60 * 2
    self.enemy_id = 320
    self.enemies = {}
    self.enemy_speed = 0.1

    self.enemy_handler = EntityHandler()
    self.exp_handler = EntityHandler()
    self.sfx_handler = EntityHandler()

    self.particle_handler = EntityHandler(PARTICLE_LIMIT)
    self.particle_handler_bg = EntityHandler(PARTICLE_LIMIT)

    -- upgrade text
    self.upgrade_prompt = {
        text = "",
        time = 0,
        max_time = 60*3,
        x = 0,
        y = 0,
    }

    self.controlled_random_drop = ControlledRandom(CONFIG.GLOBAL.DROP_RATE)

    if DEBUG_MODE then
        self:_debug_set_wave(DEBUG_WAVE_CONFIG.WAVE)
        self:_debug_set_level(DEBUG_WAVE_CONFIG.LEVEL)

        self.METRICS = {
            MAVG = {
                N = 1,
                CAVG = 0,

                RESET = function (self)
                    self.N = 1
                    self.CAVG = 0
                end,

                CALC = function (self, newV)
                    self.CAVG =  self.CAVG + (newV -  self.CAVG)/self.N
                    self.N = self.N + 1
                end
            }
        }

        -- setup hard mode
        if self.hard_mode then
            self:_debug_set_level(99)
            self.spaceship.logic.enable_rocket = true
        end
    end

    self.debug_report = ""
    self.debug_report_timeout = 0

    --- ? debug
    -- self.score = 1234
    -- self:_debug_set_level(99)
    -- self:_debug_set_wave(23)

    if DEBUG_MODE then
        self.entity_count = 0
        self.projectile_count = 0
        self.particle_count = 0
        self.entity_count_avg = 0
        self.projectile_count_avg = 0
        self.particle_count_avg = 0
        self.fps_avg = 0
        self.frame_avg = 0
    end
end

function StateLevelLogic:start()
    -- start music
    -- music(0)
    self:_play_track(DATA.TRACK.SPACE)
end

function StateLevelLogic:update(dt)
    self.camera:update(dt)

    if self.state_timeout > 0 then
        self.state_timeout = self.state_timeout - 1
    end

    if self.state == self.STATES.INTRO then
        self:_state_intro()
    elseif self.state == self.STATES.GAME then
        -- debug
        self:_debug()
        -- game state
        self:_state_game()
    elseif self.state == self.STATES.NEW_WAVE then
        self:_state_new_wave()
    elseif self.state == self.STATES.TRANS_GAMEOVER then
        self:_state_trans_gameover()
    elseif self.state == self.STATES.GAMEOVER then
        self:_state_gameover()
    end
end

function StateLevelLogic:spawn_projectile(source, handler, x, y, w, h, normal, speed, acc, update_func, mod_animate)
    -- (game_logic, x, y, w, h, normal, speed, acc, update_func, mod_animate)
    
    local projectile = ProjectileEntity(
        source,
        self,
        x, y,
        normal,
        speed,
        acc,
        update_func,
        mod_animate
    )
    projectile:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, 0, 0, w, h)
    handler:add(projectile)
end

function StateLevelLogic:particle_explosion(cx, cy)
    for i = 1, 13 do
        PARTICLE_FACTORY.explosion(self.particle_handler, cx, cy)
    end
end

local slowdown_timeout = 60
function StateLevelLogic:_debug()
    if not DEBUG_MODE then return end

    if self.current_wave_time == 0 then
        self.METRICS.MAVG:RESET()
    end
    if self.debug_report_timeout > 0 then
        self.debug_report_timeout = self.debug_report_timeout - 1
    end

    local complexity = self.enemy_handler:size() + self.enemy_projectile_handler:size() + self.exp_handler:size() + self.projectile_handler:size()
    self.METRICS.MAVG:CALC(complexity)

    -- 27 = 0
    -- 28 = 1
    -- 29 = 2
    -- 30 = 3
    -- 31 = 4
    -- 32 = 5
    -- 33 = 6
    -- 34 = 7
    -- 35 = 8
    -- 36 = 9
    -- 63 = CTRL
    -- 64 = SHIFT
    -- 65 = ALT
    -- 01 = A
    -- 02 = B
    -- 03 = C
    -- 04 = D
    -- 05 = E
    -- 06 = F
    -- 07 = G
    -- 08 = H
    -- 09 = I
    -- 10 = J
    -- 11 = K
    -- 12 = L
    -- 13 = M
    -- 14 = N
    -- 15 = O
    -- 16 = P
    -- 17 = Q
    -- 18 = R
    -- 19 = S
    -- 20 = T
    -- 21 = U
    -- 22 = V
    -- 23 = W
    -- 24 = X
    -- 25 = Y
    -- 26 = Z
    -- command --
    -- ctrl 63

    local command_key = true -- 64 -- 63

    if key(command_key) then
        if self:_debug_key(28) then
            DEBUG_DISPLAY = not DEBUG_DISPLAY
            DEBUG_WAVE_DISPLAY = false
        end
        -- bound boxes
        if self:_debug_key(29) then
            DEBUG_BOUNDINGBOX = not DEBUG_BOUNDINGBOX
        end
        -- hp debug
        if self:_debug_key(30) then
            DEBUG_HP = not DEBUG_HP

            if DEBUG_HP then
                self:_debug_report("Invincibility ON")
            else
                self:_debug_report("Invincibility OFF")
            end
        end
        -- wave info
        if self:_debug_key(31) then
            DEBUG_WAVE_DISPLAY = not DEBUG_WAVE_DISPLAY
            DEBUG_DISPLAY = false
        end
        -- DEBUG WAVE
        if self:_debug_key(32) then
            DEBUG_WAVE = false
        end
    end

    -- game --
    -- hp -- q
    if self:_debug_key(17) then
        self.spaceship.logic.hp = lazy.math.lower_bound(self.spaceship.logic.hp - 120, 0)
        self:_debug_report("Damage")
    end
    if self:_debug_key(16) then
        self.spaceship.logic.hp = 0
        self:_debug_report("Kill")
    end
    -- TODO hp gain

    -- E level + 1
    if self:_debug_key(05) then
        self.spaceship.logic.exp = lazy.math.upper_bound(self.spaceship.logic.exp + CONFIG.SPACESHIP.EXP, CONFIG.SPACESHIP.EXP)
        self:_debug_report("+ level")
    end
    -- level + 10
    if self:_debug_key(18) then
        -- self.spaceship.logic.exp = lazy.math.upper_bound(self.spaceship.logic.exp + CONFIG.SPACESHIP.EXP, CONFIG.SPACESHIP.EXP)
        self:_debug_set_level(5)
        self:_debug_report("+5 level")
    end
    -- level 99
    if self:_debug_key(20) then
        self:_debug_set_level(99)
        self:_debug_report("Max level")
    end
    -- y 25 - next wave
    if self:_debug_key(25) then
        self.current_wave_time = 0
        self:_debug_report("Next wave")

        self:_debug_set_level(3)
    end

    -- wave 44 = GRAVE
    if self:_debug_key(44) then
        self:_wipe_screen()
        self:_debug_report("Kill enemies")
    end

    if DEBUG_WAVE then
        -- zombie
        -- a
        if key(01) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyZombieShip, WAVE_CONFIG.ZOMBIE[config_key])
            end
        end
        -- s
        if key(19) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyShooter, WAVE_CONFIG.SHOOTER[config_key])
            end
        end
        -- d
        if key(04) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyPeek, WAVE_CONFIG.PEEK[config_key])
            end
        end
        -- f 06
        if key(06) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyMedusa, WAVE_CONFIG.MEDUSA[config_key])
            end
        end
        -- g 07
        if key(07) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyKamikaze, WAVE_CONFIG.KAMIKAZE[config_key])
            end
        end
        -- h 08
        if key(08) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyBounce, WAVE_CONFIG.BOUNCE[config_key])
            end
        end
        -- j 10
        if key(10) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemyOrganic, WAVE_CONFIG.ORGANIC[config_key])
            end
        end
        -- k 11
        if key(11) then
            local index = self:_get_index_from_key()
            local config_key = WAVE_KEY[index]

            if config_key then
                self:_debug_spawn(EnemySeeker, WAVE_CONFIG.SEEKER[config_key])
            end
        end
        -- 12 = L
        if self:_debug_key(12) then
            self:_debug_spawn(EnemyHeart, { 99999, 10 })
        end
    end

    local fps = FPS:getValue()
    local frame = lazy.math.round((fps / 60), 0.1)

    self.entity_count = self.enemy_handler:size()
        + self.exp_handler:size()
        + self.sfx_handler:size()
    self.projectile_count = self.projectile_handler:size()
        + self.enemy_projectile_handler:size()
    self.particle_count = self.particle_handler:size()

    local time = 60 * 3
    self.fps_avg = lazy.math.rollingAverage(self.fps_avg, fps, time)
    self.frame_avg = lazy.math.rollingAverage(self.frame_avg, frame, time)
    time = 15
    self.entity_count_avg = lazy.math.rollingAverage(self.entity_count_avg, self.entity_count, time)
    self.projectile_count_avg = lazy.math.rollingAverage(self.projectile_count_avg, self.projectile_count, time)
    self.particle_count_avg = lazy.math.rollingAverage(self.particle_count_avg, self.particle_count, time)

    if DEBUG_SLOWDOWN_DETECT then
        if slowdown_timeout > 0 then
            slowdown_timeout = slowdown_timeout - 1
        elseif slowdown_timeout == 0 and fps < 58 then
            slowdown_timeout = 60

            local total = self.entity_count + self.projectile_count + self.particle_count

            --self.entity_count_avg = lazy.math.rollingAverage(self.entity_count_avg, entity_count, time)
            --self.projectile_count_avg = lazy.math.rollingAverage(self.projectile_count_avg, projectile_count, time)
            --self.particle_count_avg = lazy.math.rollingAverage(self.particle_count_avg, particle_count, time)

            trace("-----")
            trace("SLOWDOWN @ wave "..self.wave)
            trace("FPS: "..fps)
            trace("MEM: entity:"..self.entity_count.." proj:"..self.projectile_count.." par: "..self.particle_count.." total:"..total)
            trace("MEM AVG: entity:"..self.entity_count_avg.." proj:"..self.projectile_count_avg.." par: "..self.particle_count_avg)
        end
    end
end

local KEY_HOLD = 10
local KEY_AUTO = 15

function StateLevelLogic:_debug_key(key)
    return keyp(key, KEY_HOLD, KEY_AUTO)
end

function StateLevelLogic:_debug_report(text)
    self.debug_report = text
    self.debug_report_timeout = 90
end

function StateLevelLogic:_get_index_from_key()
    for key = 28, 36 do
        if keyp(key, KEY_HOLD, KEY_AUTO) then
            return key - 27
        end
    end

    if keyp(27, KEY_HOLD, KEY_AUTO) then
        return 10
    end

    return -1
end

function StateLevelLogic:_debug_set_wave(wave)
    self.wave = lazy.math.bound(wave - 1, 0, #WAVE_DATA - 1)
end

function StateLevelLogic:_debug_set_level(level)
    for i = 1, level do
        self.spaceship.logic.exp = CONFIG.SPACESHIP.EXP
        self.spaceship.logic:checkLevelUp()
        UPGRADE.apply(self.spaceship, self.control_ball)
    end
end

function StateLevelLogic:_debug_spawn(Klass, config)
    local enemy = Klass(self, config)
    enemy:spawn()
end

function StateLevelLogic:_state_intro()
    -- self.state = self.STATES.GAME
    self.intro_time = self.intro_time - 1

    local a = 1 - self.intro_time / self.intro_time_max
    local t = lazy.tween.func.easeOutBack(a)
    local y = lazy.math.lerp(t, CONFIG.GAME.VIEWPORT.H + 32, CONFIG.SPACESHIP.Y)

    self.spaceship.y = lazy.math.round(y)
    self.spaceship:update(1)

    if self.intro_time == 0 then
        self.state = self.STATES.GAME
    end
end

function StateLevelLogic:_state_game()
    self:_game_wave_setup()

    if self.wave_text_timer  ~= 0 then
        self.wave_text_timer  = self.wave_text_timer  - 1
    end

    if self.upgrade_prompt.time ~= 0 then
        self.upgrade_prompt.time = self.upgrade_prompt.time - 1
    end

    -- Updates
    self.projectile_handler:update(dt)
    self.enemy_projectile_handler:update(dt)
    self.enemy_handler:update(dt)
    self.control_ball:update(dt)
    self.spaceship:update(dt)
    self.exp_handler:update(dt)
    self.sfx_handler:update(dt)
    self.particle_handler:update(dt)
    self.particle_handler_bg:update(dt)

    self:_game_enemy_update()
    self:_game_collisions()

    -- particle spawning: projectiles
    self.projectile_handler:loop(
        function(projectile)
            if FRAME % 2 == 0 then
                PARTICLE_FACTORY.bullet_trail(self.particle_handler, projectile.x, projectile.y)
            end
        end
    )

    self.enemy_projectile_handler:loop(
        function(projectile)
            if FRAME % 3 == 0 then
                -- PARTICLE_FACTORY.enemy_bullet_trail(self.particle_handler, projectile.x, projectile.y)
                PARTICLE_FACTORY.enemy_bullet_trail(self.particle_handler, projectile.x, projectile.y)
            end
        end
    )

    -- check level up
    if self.spaceship.logic:checkLevelUp() then
        UPGRADE.apply(self.spaceship, self.control_ball)

        self.upgrade_prompt.text = UPGRADE.getText(self.spaceship)

        self.upgrade_prompt.time = self.upgrade_prompt.max_time
        self.upgrade_prompt.x = CONFIG.GAME.VIEWPORT.W / 2
        self.upgrade_prompt.y = CONFIG.GAME.VIEWPORT.H - 8
    end

    -- check gameover
    if DEBUG_HP and self.spaceship.logic.hp == 0 then
        self.spaceship.logic.hp = CONFIG.SPACESHIP.HP
        self:_debug_report("HP is 0")
    end

    if self.spaceship.logic.hp == 0 then
        self.state = self.STATES.TRANS_GAMEOVER

        self.has_new_score = self.score > self.score_top

        self.upgrade_prompt.time = 0
        self.wave_text_timer = 0

        -- update to remove entity
        self.enemy_handler:update(dt)

        self:particle_explosion(self.spaceship.x + self.spaceship.w / 2, self.spaceship.y + self.spaceship.h / 2)
        self.sfx_handler:add(SfxEntity(self.spaceship.x, self.spaceship.y, DATA.GFX.EXPLOSION))
        DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
        self.camera:shake(5, 90)
    end
end

function StateLevelLogic:_state_trans_gameover()
    -- Update objects
    --self.projectile_handler:update(dt)
    --self.enemy_projectile_handler:update(dt)
    --self.enemy_handler:update(dt)
    --self.control_ball:update(dt)
    --self.spaceship.x = self.control_ball.x
    --self.spaceship:update(dt)
    --self.exp_handler:update(dt)
    self.sfx_handler:update(dt)
    self.particle_handler:update(dt)

    if self.sfx_handler:isEmpty() and self.particle_handler:isEmpty() then
        self.state = self.STATES.GAMEOVER
        self.state_timeout = STATE_GAMEOVER_TIMEOUT_MAX
    end
end

function StateLevelLogic:_state_gameover()
    if self.state_timeout == 0 then
        pmem(0, self.score)

        STATE_MANAGER:next(TransitionSlide(
                STATE_MANAGER,
                CONFIG.UI.TRANSITION_TIME,
                self.base_state,
                StateIntro()
            ))
    end
end

function StateLevelLogic:_state_new_wave()
    self.projectile_handler:update(1)
    self.enemy_handler:update(1)
    self.spaceship:update(1)

    if self.enemy_handler:isEmpty() then
        self.projectile_handler:clear()

        self.score = self.score + CONFIG.GLOBAL.SCORE.PER_WAVE
        
        self.state = self.STATES.GAME
    end
end

function StateLevelLogic:_wipe_screen()
    self.enemy_handler:loop(
        function(enemy)
            enemy.logic:kill()
        end
    )

    self.enemy_projectile_handler:loop(
        function(entity)
            entity.delete = true
        end
    )

    self.projectile_handler:loop(
        function(entity)
            -- entity.delete = true
        end
    )

    if not self.enemy_handler:isEmpty() then
        -- DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    end
end

function StateLevelLogic:_game_wave_setup()
    if DEBUG_WAVE then return end

    -- colelct garbage
    collectgarbage("collect")

    -- setup wave
    if self.current_wave_time == 0 then
        -- set wave
        self.wave = self.wave + 1

        -- reset demo wave
        if DEMO_MODE and self.wave > #WAVE_DATA then
            self.wave = 1
        end

        -- reset quasar level
        if self.wave > #WAVE_DATA then
            -- self.wave = self.quasar_level
            self.wave = 1
            self.quasar_mode = false
            self.hard_mode = true
            self.quasar_level = -1 

            self:_play_track(DATA.TRACK.SPACE)

            -- rocket check
            if not self.spaceship.enable_rocket then
                self.spaceship.logic.enable_rocket = true

                self.upgrade_prompt.text = "+ Rocket"
                self.upgrade_prompt.time = self.upgrade_prompt.max_time
                self.upgrade_prompt.x = CONFIG.GAME.VIEWPORT.W / 2
                self.upgrade_prompt.y = CONFIG.GAME.VIEWPORT.H - 8

                self.spaceship.logic.flashing:start(30)
            end
        end

        self.current_wave = WAVE_DATA[self.wave]
        
        -- reset track from boss mode
        if self.boss_mode then
            if self.quasar_level == -1 then
                -- self:_play_track(DATA.TRACK.QUASAR)
                self:_play_track(DATA.TRACK.SPACE)
            end
        end

        -- set mode
        self.boss_mode = false
        self.wave_time_max = CONFIG.LEVEL.WAVE_TIMEOUT
        if self.current_wave.set_boss_mode then
            self.boss_mode = true
            local last_boss_offset = (self.wave == #WAVE_DATA) and 1400 or 0
            self.wave_time_max = CONFIG.LEVEL.WAVE_BOSS_TIMEOUT + last_boss_offset

            if self.quasar_level == -1  then
                self:_play_track(DATA.TRACK.BOSS)
            end
        end
        if DEMO_MODE then 
            self.wave_time_max = self.wave_time_max / 2
        end
        self.current_wave_time = self.wave_time_max

        if self.current_wave.set_quasar_mode then
            if self.quasar_level == -1 then
                self:_play_track(DATA.TRACK.QUASAR)
            end

            self.quasar_mode = true
            self.quasar_level = self.wave
        end

        self.current_wave:initiate(self)

        self.state = self.STATES.NEW_WAVE
        self:_wipe_screen()
        self.wave_text_timer = CONFIG.LEVEL.WAVE_TEXT_TIMER_MAX
        return
    else
        self.current_wave_time = self.current_wave_time - 1
    end

    -- wave update
    self.wave_percent = self.current_wave_time / self.wave_time_max
    self.current_wave:exec(self)
end

function StateLevelLogic:_game_enemy_update()
    self.enemy_handler:loop(
        function(enemy_entity)
            -- ship vs enemy collision
            local death_by_player = false

            if not enemy_entity:typeof(EnemyPeek)
            and lazy.util.bouding_box_collision(CONFIG.GLOBAL.KEY_HITBOX, enemy_entity, self.spaceship) then
                enemy_entity.logic:kill()
                --self.spaceship.

                if enemy_entity.logic.damage ~= nil then
                    local penalty = enemy_entity.logic.use_alt_pal and CONFIG.GLOBAL.DAMAGE_COLLISION_PENALTY or 0
                    local damage = enemy_entity.logic.damage + penalty
                    self.spaceship.logic.hp = lazy.math.lower_bound(self.spaceship.logic.hp - damage, 0)
                else
                    local penalty = enemy_entity.logic.use_alt_pal and CONFIG.GLOBAL.DAMAGE_COLLISION_PENALTY or 0
                    local damage = CONFIG.GLOBAL.DAMAGE_COLLISION + penalty
                    self.spaceship.logic.hp = lazy.math.lower_bound(self.spaceship.logic.hp - damage, 0)
                    -- lazy.log("WARNING: nil 'collision' damage value.")
                end

                self.spaceship.logic.flashing:start()
                self.camera:shake(3, 20)
            end

            -- enemy vs player projectile collision
            self.projectile_handler:loop(
                function(projectile_entity)
                    if lazy.util.bouding_box_collision(CONFIG.GLOBAL.KEY_HITBOX, enemy_entity, projectile_entity) then
                        if enemy_entity.logic.hp == 0 then return end

                        projectile_entity.delete = true

                        if projectile_entity.logic.explode then
                            projectile_entity.game_logic:particle_explosion(projectile_entity.x + projectile_entity.w / 2, projectile_entity.y + projectile_entity.h / 2)
                            projectile_entity.game_logic.sfx_handler:add(SfxEntity(projectile_entity.x, projectile_entity.y, DATA.GFX.EXPLOSION_KAMIKAZE))
                            DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
                            DATA.CAMERA.ENEMY_EXPLOSION:shake(projectile_entity.game_logic.camera)
                        
                            local damage = CONFIG.SPACESHIP.PROJECTILE_ROCKET_DAMAGE 
                              + CONFIG.SPACESHIP.PROJECTILE_ROCKET_WAVE_ADD * self.wave

                            enemy_entity.logic.hp = lazy.math.lower_bound(enemy_entity.logic.hp - damage, 0)
                            enemy_entity.logic.flashing:start()
                        elseif enemy_entity.logic:is_immune() then
                            DATA.SFX[DATA.SFX.INDEX.IMMUNE_BULLET]:play()
                        else
                            enemy_entity.logic.hp = lazy.math.lower_bound(enemy_entity.logic.hp - 10, 0)
                            enemy_entity.logic.flashing:start()
                            DATA.SFX[DATA.SFX.INDEX.BULLET_COLLIDE]:play()
                        end

                        death_by_player = true
                    end
                end
            )

            --- TODO needs to be in the enemy update function?
            if enemy_entity.logic.hp == 0 then
                enemy_entity.logic:kill()

                if death_by_player then
                    -- local exp_entity = enemy_entity.logic:drop_item()
                    local type_i = self.controlled_random_drop:next()
                    local exp_entity = ExpEnitity(
                        type_i,
                        enemy_entity.x + 8 - 4, enemy_entity.y + 8 - 4
                    )

                    self.exp_handler:add(exp_entity)

                    -- auto pickup item if below player
                    if exp_entity.y > self.spaceship.y
                        and exp_entity.state ~= exp_entity.STATES.IN then
                        exp_entity.state = exp_entity.STATES.IN
                        exp_entity:setInEntity(self.spaceship)
                    end

                    -- score
                    self.score = self.score + CONFIG.GLOBAL.SCORE.SHIP_KILL
                end
            end
            -- check enemy death
            if false then
                enemy_entity.logic:kill()
                -- enemy_entity.delete = true

                -- no drops if collision
                if death_by_player then
                    local type_i = UTILITY.get_weighted_value(CONFIG.GLOBAL.DROP_RATE_TEST)

                    self.exp_handler:add(ExpEnitity(
                        type_i,
                        enemy_entity.x + 4, enemy_entity.y + 4
                    ))
                end

                if enemy_entity:typeof(EnemyPeek) then
                    
                elseif enemy_entity:typeof(EnemyKamikaze) then
                    
                elseif enemy_entity:typeof(EnemyOrganic) then
                    
                elseif enemy_entity:typeof(EnemyZombieShip) then
                    
                else
                    self:particle_explosion(enemy_entity.x + enemy_entity.w / 2, enemy_entity.y + enemy_entity.h / 2)
                    self.sfx_handler:add(SfxEntity(enemy_entity.x, enemy_entity.y, DATA.GFX.EXPLOSION))
                end

                self:_game_increase_score(1)

                DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
                self.camera:shake(1, 20)
            end
        end
    )
end

--- TODO move to entity logic
function StateLevelLogic:_game_collisions()
    -- collide enemy projectiles vs spaceship
    self.enemy_projectile_handler:loop(
        function(proj)
            if lazy.util.bouding_box_collision(CONFIG.GLOBAL.KEY_HITBOX, self.spaceship, proj) then
                if self.spaceship.logic.hp == 0 then return end

                if proj.source.logic.projectile_damage ~= nil then
                    local penalty = proj.source.logic.use_alt_pal and CONFIG.GLOBAL.DAMAGE_PROJECTILE_PENALTY or 0
                    local damage = proj.source.logic.projectile_damage + penalty
                    self.spaceship.logic.hp = lazy.math.lower_bound(self.spaceship.logic.hp - damage, 0)
                else
                    local damage = CONFIG.GLOBAL.DAMAGE_PROJECTILE
                    self.spaceship.logic.hp = lazy.math.lower_bound(self.spaceship.logic.hp - damage, 0)
                end

                self.spaceship.logic.flashing:start()

                proj.delete = true
                DATA.SFX[DATA.SFX.INDEX.BULLET_COLLIDE]:play()
                self.camera:shake(3, 20)
            end
        end
    )

    -- collide exp capsule vs spaceship
    self.exp_handler:loop(
        function(exp_entity)

            local dist_e = lazy.math.distance(
                exp_entity.x + 4, exp_entity.y + 4,
                self.spaceship.x + 8, self.spaceship.y + 8
            )

            if dist_e < CONFIG.SPACESHIP.PICK_UP_RADIUS 
            and exp_entity.state ~= exp_entity.STATES.IN then
                exp_entity.state = exp_entity.STATES.IN
                exp_entity:setInEntity(self.spaceship)
            end
        end
    )

    -- EnemyPeek wall stop
    -- TODO mode to entity logic
    self.enemy_handler:loop(
        function(enemy) 
            if enemy:typeof(EnemyPeek) then
                local s_y = self.spaceship.y + CONFIG.SPACESHIP.HITBOX.Y + CONFIG.SPACESHIP.HITBOX.H
                local e_y = enemy.y

                local spaceship_x0 = self.spaceship.x + CONFIG.SPACESHIP.HITBOX.X
                local spaceship_w = CONFIG.SPACESHIP.HITBOX.W
                local spaceship_x1 = spaceship_x0 + spaceship_w

                if e_y < s_y
                and spaceship_x1 > enemy.x and spaceship_x1 < enemy.x + 8
                then
                    self.control_ball.x = enemy.x - spaceship_w - CONFIG.SPACESHIP.HITBOX.X
                    self.spaceship.x = self.control_ball.x
                elseif  e_y < s_y
                and spaceship_x0 < enemy.x + 16 and spaceship_x0  > enemy.x + 8
                then
                    self.control_ball.x = enemy.x + spaceship_w + CONFIG.SPACESHIP.HITBOX.X
                    self.spaceship.x = self.control_ball.x
                end
            end
        end
    )
end

function StateLevelLogic:_game_increase_score(value)
    self.score = lazy.math.upper_bound(self.score + value, CONFIG.GLOBAL.SCORE_MAX)
end

function StateLevelLogic:_explode_enemy(enemy) 
    -- TODO implementation
end

function StateLevelLogic:_play_track(id)
    if DEBUG_MODE and DEBUG_NO_MUSIC then return end

    if self.play_music then
        music(id)
        self.current_track_id = id
    end
end