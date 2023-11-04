EnemySeekerLogic = lazy.extend("EnemySeekerLogic", EnemyBaseLogic)

local PI2 = math.pi * 2

local FOLLOW_BUFFER = 14
local BASE_ANGLE = 28

function EnemySeekerLogic:constructor(entity)
    self.entity = entity
    self.flashing = Flashing()

    self.flashing:start()

    self.STATES = lazy.enum("INTRO", "ATTACK")
    self.state = self.STATES.MOVE
    self.state_count = 0

    local config = self.entity.config
    self.hp_mod = config[1]
    -- self.move_speed_mod = config[2]
    self.use_alt_pal = config[2]
    self.pal_mode = config[3]

    self.mode = config[4]
    self.projectile_speed = config[5] -- 0.2
    self.projectile_acc = config[6] -- 0.0038
    self.attack_frame = config[7] -- 120
    self.accuracy_acc = config[8] -- 0.06
    self.spawn_mode = config[9] -- 2

    self.accuracy = 0

    self.projectile_damage = CONFIG.ENEMY.SEEKER.DAMAGE_PROJECTILE

    -- update logic
    self.hp = self.hp_mod

    self.animation_projectile = ModAnimate({295, 295}, 2)

    self.frame_offset = math.random(0, self.attack_frame)

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemySeekerLogic:update(dt)
    self.flashing:update(dt)

    if (FRAME + self.frame_offset) % self.attack_frame == 0 then
        self:_fire_weapon()
    end
    
end

function EnemySeekerLogic:_fire_weapon()
    local normal = {}
    
    -- down
    if self.mode == 1 then
        normal = lazy.math.normalAngleDegree(90)
    -- aim
    elseif self.mode == 2 then
        normal = lazy.math.normal(
            self.entity.x + 12,
            self.entity.y + 4,
            self.entity.game_logic.spaceship.x + 8,
            self.entity.game_logic.spaceship.y + 8
        )
    -- random
    elseif self.mode == 3 then
        local angle = math.rad(270+math.random(-45, 45))
        normal = lazy.math.normalAngleRad(angle)
    end

    local accuracy_acc = self.accuracy_acc
    local update_func = function(self)
        if self.accuracy then
            -- self.accuracy = self.accuracy + self.accuracy_acc
            
        else
            -- self.accuracy = 0
            -- self.accuracy_acc = accuracy_acc
            self.accuracy = accuracy_acc
        end

        if self.entity.y < CONFIG.SPACESHIP.Y - FOLLOW_BUFFER then
            local ship = self.entity.game_logic.spaceship
            local s_norm = lazy.math.normal(self.entity.x + 2, self.entity.y + 2, ship.x + 8, ship.y + 8)

            local angle_ship = lazy.math.normalizeAngleRad(math.atan(s_norm.y, s_norm.x))
            local angle_ent = lazy.math.normalizeAngleRad(math.atan(self.normal.y, self.normal.x))

            if angle_ent > 3/4*PI2 and angle_ent < PI2 then
                angle_ent = angle_ent - PI2
            end

            local angle = angle_ent + (angle_ship - angle_ent) * self.accuracy

            self.normal = lazy.math.normalAngleRad(angle)
        end

        self.entity.x = self.entity.x + self.speed * self.normal.x
        self.entity.y = self.entity.y + self.speed * self.normal.y

        self.speed = self.speed + self.acc
    end
    
    self.entity.game_logic:spawn_projectile(
        self.entity,
        self.entity.game_logic.enemy_projectile_handler,
        self.entity.x + 10, self.entity.y + 4,
        4, 4,
        normal,
        self.projectile_speed,
        self.projectile_acc,
        update_func,
        self.animation_projectile
    )

    DATA.SFX[DATA.SFX.INDEX.FOLLOW_BULLET]:play()

    -- DATA.SFX[DATA.SFX.INDEX.EYE_BULLET]:play()
end

function EnemySeekerLogic:kill()
    self.entity.delete = true

    local game_logic = self.entity.game_logic

    game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + self.entity.h / 2)
    game_logic.sfx_handler:add(SfxEntity(self.entity.x + self.entity.w / 2 - 8, self.entity.y + self.entity.h / 2 - 8, DATA.GFX.EXPLOSION))

    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(game_logic.camera)
end