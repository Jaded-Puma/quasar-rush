EnemyKamikazeLogic = lazy.extend("EnemyKamikazeLogic", EnemyBaseLogic)

local WAIT_TIMEOUT = 60
local JERK = 0.01
local FIND_DIST = 55

function EnemyKamikazeLogic:constructor(entity)
    self.entity = entity
    self.flashing = Flashing()

    self.STATES = lazy.enum("WAIT", "FIND", "AIM", "ATTACK")
    self.state = self.STATES.WAIT
    self._state_timeout = math.random(0 , WAIT_TIMEOUT)

    self.isAimAttack = false

    local config = self.entity.config
    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.aim_timeout_mod = config[5]
    self.attack_timeout_mod = config[6]

    -- update logic
    self.hp = self.hp_mod
    self.move_speed  = self.move_speed_mod
    self.aim_timer = self.aim_timeout_mod
    self.attack_timeout = self.attack_timeout_mod

    self.damage = CONFIG.ENEMY.KAMIKAZE.DAMAGE_COLLISION

    self.normal_direction_vec = {}

    -- ! depricated values
    self.current_acc = 0
    self.current_speed = 0

    self.start_pos = {}
    self.distance = 0
    self.attack_count = 0
    self.a = 0

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyKamikazeLogic:update(dt)
    self.flashing:update(dt)
    local spaceship = self.entity.game_logic.spaceship

    if self.state == self.STATES.WAIT then
        self._state_timeout = self._state_timeout - 1
        if self._state_timeout == 0 then
            self.state = self.STATES.FIND
        end
    elseif self.state == self.STATES.FIND then
        self.entity.x = self.entity.x + self.spawn_dir * self.move_speed

        if math.abs( (self.entity.x + 8) - (spaceship.x + 8)) < FIND_DIST
        and self.entity.x > 0
        and self.entity.x < CONFIG.GAME.VIEWPORT.W - 16
        then
            self.state = self.STATES.AIM
        end
    elseif self.state == self.STATES.AIM then
        self.aim_timer = self.aim_timer - 1

        if self.aim_timer == 0 then
            self.isAimAttack = true
            self.state = self.STATES.ATTACK
            self.normal_direction_vec = lazy.math.normal(
                self.entity.x + 8, self.entity.y + 8, 
                spaceship.x + 8, spaceship.y + 8
            )

            self.start_pos = lazy.util.position(self.entity.x, self.entity.y)
            local offset_x = 8 + self.normal_direction_vec.x * 8
            local offset_y = 8 + self.normal_direction_vec.y * 8
            self.distance = lazy.math.distance(
                self.entity.x + 8, self.entity.y + 8, 
                spaceship.x + offset_x, spaceship.y + offset_y
            )
        end
    elseif self.state == self.STATES.ATTACK then
        local max_time = self.attack_timeout

        self.a = self.attack_count / max_time
        self.t = lazy.tween.func.easeInBack(self.a)

        self.entity.x = self.start_pos.x + self.t * self.normal_direction_vec.x * self.distance
        self.entity.y = self.start_pos.y + self.t * self.normal_direction_vec.y * self.distance

        if self.attack_count == max_time then
            self:kill()
        end

        self.attack_count = lazy.math.upper_bound(self.attack_count + 1, max_time)
    end

    if self.state == self.STATES.ATTACK
    and FRAME % 2 == 0 then
        PARTICLE_FACTORY.aim_attack_trail(
            self.entity.game_logic.particle_handler,
            self.entity.x + 8 - 1, self.entity.y + 8 - 1
        )
    end
end

function EnemyKamikazeLogic:kill()
    self.entity.delete = true
    self.entity.game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + self.entity.h / 2)
    self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y, DATA.GFX.EXPLOSION_KAMIKAZE))
    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(self.entity.game_logic.camera)
end