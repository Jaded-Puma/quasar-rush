EnemyOrganicLogic = lazy.extend("EnemyOrganicLogic", EnemyBaseLogic)

local PI2 = math.pi * 2
local BASE_ANGLE = 28

function EnemyOrganicLogic:constructor(entity)
    self.entity = entity
    self.flashing = Flashing()

    self.STATES = lazy.enum("MOVE", "ANTICIPATION", "SHOOT", "COOLDOWN")
    self.state = self.STATES.MOVE
    self.state_count = 0

    local config = self.entity.config
    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.mode = config[5]
    self.attack_timeout_mod = config[6]
    self.projectile_speed_mod = config[7]

    -- update logic
    self.hp = self.hp_mod
    self.move_speed  = self.move_speed_mod
    self.attack_time_max = self.attack_timeout_mod
    self.attack_time = math.random(1, self.attack_time_max)

    self.projectile_damage = CONFIG.ENEMY.ORGANIC.DAMAGE_PROJECTILE

    self.angle_time_max = CONFIG.ENEMY.ORGANIC.ANGLE_TIME_MAX
    self.angle_time  = -1

    -- self.strech = CONFIG.VIEWPORT.W

    self.base_y = CONFIG.GAME.VIEWPORT.H / 2 - 32
    self.start_angle = 0 -- PI2 * math.random()

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyOrganicLogic:update(dt)
    self.flashing:update(dt)

    local speed = 0

    if self.state == self.STATES.MOVE then
        speed = self.move_speed

        self.angle_time = self.angle_time + 1
        
        if self.entity.x > 0 and self.entity.x < CONFIG.GAME.VIEWPORT.W - 16 then
            self.attack_time = self.attack_time - 1
            if self.attack_time == 0 then
                self.state = self.STATES.ANTICIPATION
                self.state_count = CONFIG.ENEMY.ORGANIC.SHOOT_ANTICIPATION
            end
        end
    elseif self.state == self.STATES.ANTICIPATION then
        speed = self.move_speed * CONFIG.ENEMY.ORGANIC.MOVE_SPEED_ANTICIPATION_MUL

        self.state_count = self.state_count  - 1
        if self.state_count == 0 then
            self.state = self.STATES.SHOOT
        end
    elseif self.state == self.STATES.SHOOT then
        speed = self.move_speed * CONFIG.ENEMY.ORGANIC.MOVE_SPEED_ANTICIPATION_MUL

        self.state = self.STATES.COOLDOWN
        self:_fire_weapon()
        self.state_count = CONFIG.ENEMY.ORGANIC.SHOOT_COOLDOWN
    elseif self.state == self.STATES.COOLDOWN then
        speed = self.move_speed * CONFIG.ENEMY.ORGANIC.MOVE_SPEED_ANTICIPATION_MUL

        self.state_count = self.state_count  - 1
        if self.state_count == 0 then
            self.state = self.STATES.MOVE
            self.attack_time = self.attack_time_max
        end
    end

    
    self.entity.x = self.entity.x + self.spawn_dir * speed
    local angle = self.angle_time / self.angle_time_max
    local theta = self.start_angle + PI2 * angle

    local hsum = 0
    if self.mode == 3 then
        hsum = (math.sin(10.3 * theta) / 6) - 0.4
    else
        local h1 = math.sin(theta)
        local h2 = math.sin(10.3 * theta) / 6
        hsum  = h1 + h2
    end

    self.entity.y = self.base_y + 12 * hsum

    if self.entity.x + 16 >= CONFIG.GAME.VIEWPORT.W - CONFIG.ENEMY.ORGANIC.X_BUFFER then
        self.spawn_dir = -1
    elseif self.entity.x <= CONFIG.ENEMY.ORGANIC.X_BUFFER then
        self.spawn_dir = 1
    end

    -- if self.angle_time == 0 then
    --     self.angle_time = self.angle_time_max
    -- end
end

function EnemyOrganicLogic:_fire_weapon()
    -- handler, x, y, w, h, normal, speed, acc, update_func, mod_animate)

    local normal = lazy.math.normal(
        self.entity.x + 8,
        self.entity.y + 4,
        self.entity.game_logic.spaceship.x + 8,
        self.entity.game_logic.spaceship.y + 8
    )

    if self.mode == 3 then
        local rate = 1/180
        local amp = 38

        local update_func = function (self)
            self.angle = self.angle + rate
            --self.entity.y = self.entity.y + self.speed * self.normal.y
            --self.entity.x = self.base_x + 20 * math.sin(self.angle)

            --self.speed = self.speed + self.acc

            self.base_x = self.base_x + self.speed * self.normal.x
            self.base_y = self.base_y + self.speed * self.normal.y

            self.entity.x = self.base_x + amp * math.cos(PI2 * self.angle)
            self.entity.y = self.base_y + amp * math.sin(PI2 * self.angle)
        end 

        local update_func2 = function (self)
            self.angle = self.angle + rate
            --self.entity.y = self.entity.y + self.speed * self.normal.y
            --self.entity.x = self.base_x + 20 * math.sin(self.angle)

            --self.speed = self.speed + self.acc

            self.base_x = self.base_x + self.speed * self.normal.x
            self.base_y = self.base_y + self.speed * self.normal.y

            self.entity.x = self.base_x + amp * math.cos(math.pi + PI2 * self.angle)
            self.entity.y = self.base_y + amp * math.sin(math.pi + PI2 * self.angle)
        end 

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            self.entity.x + 8, self.entity.y + 4,
            4, 4,
            normal,
            self.projectile_speed_mod,
            0,
            update_func,
            self.entity.game_logic.projectile_enemy_organic_anim
        )
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            self.entity.x + 8, self.entity.y + 4,
            4, 4,
            normal,
            self.projectile_speed_mod,
            0,
            update_func2,
            self.entity.game_logic.projectile_enemy_organic_anim
        )
    else
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            self.entity.x + 8, self.entity.y + 4,
            4, 4,
            normal,
            self.projectile_speed_mod,
            acc,
            nil,
            self.entity.game_logic.projectile_enemy_organic_anim
        )
    end

    local normal = lazy.math.normal(
        self.entity.x + 8,
        self.entity.y + 4,
        self.entity.game_logic.spaceship.x + 8,
        self.entity.game_logic.spaceship.y + 8
    )
    local angle = math.deg(math.acos(normal.x))

    

    if self.mode == 2 then
        
        local normal_0 = lazy.math.normalAngleDegree(angle + BASE_ANGLE)
        local normal_1 = lazy.math.normalAngleDegree(angle - BASE_ANGLE)

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            self.entity.x + 8, self.entity.y + 4,
            4, 4,
            normal_0,
            self.projectile_speed_mod,
            0,
            nil,
            self.entity.game_logic.projectile_enemy_organic_anim
        )

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            self.entity.x + 8, self.entity.y + 4,
            4, 4,
            normal_1,
            self.projectile_speed_mod,
            0,
            nil,
            self.entity.game_logic.projectile_enemy_organic_anim
        )
    end

    if self.mode == 3 then
        -- local normal = {}
        -- normal[1] = lazy.math.normalAngleDegree(angle + BASE_ANGLE*1.5)
        -- normal[2] = lazy.math.normalAngleDegree(angle - BASE_ANGLE*1.5)
        -- normal[3] = lazy.math.normalAngleDegree(angle + BASE_ANGLE*2)
        -- normal[4] = lazy.math.normalAngleDegree(angle - BASE_ANGLE*2)
        -- normal[5] = lazy.math.normalAngleDegree(angle + BASE_ANGLE*2.5)
        -- normal[6] = lazy.math.normalAngleDegree(angle - BASE_ANGLE*2.5)

        -- for i = 1, 6 do
        --     self.entity.game_logic:spawn_projectile(
            -- self.entity,
        --     self.entity.game_logic.enemy_projectile_handler,
        --     self.entity.x + 8, self.entity.y + 4,
        --     4, 4,
        --     normal[i],
        --     self.projectile_speed_mod,
        --     0,
        --     nil,
        --     self.entity.game_logic.projectile_enemy_organic_anim
        -- )
        -- end
    end

    DATA.SFX[DATA.SFX.INDEX.EYE_BULLET]:play()
end

function EnemyOrganicLogic:kill()
    self.entity.delete = true

    local game_logic = self.entity.game_logic

    game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + self.entity.h / 2)
    game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + 16 + self.entity.h / 2)
    game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y, DATA.GFX.EXPLOSION))
    game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y + 16, DATA.GFX.EXPLOSION))

    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(game_logic.camera)
end