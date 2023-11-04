EnemyBounceLogic = lazy.extend("EnemyBounceLogic", EnemyBaseLogic)

local ANGLE_RANGE_MIN = 20
local ANGLE_RANGE_MAX = 32

function EnemyBounceLogic:constructor(entity)
    self.entity = entity
    self.flashing = Flashing()

    self.STATES = lazy.enum("BOUNCE", "ANTICIPATION")
    self.state = self.STATES.BOUNCE
    self.state_count = 0

    local config = self.entity.config
    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.bounces = config[5]
    self.inf_bounces = (self.bounces == -1)

    -- update logic
    self.hp = self.hp_mod
    self.move_speed = self.move_speed_mod
    
    self.damage = CONFIG.ENEMY.BOUNCE.DAMAGE_COLLISION

    ---
    self.DIRECTION = lazy.enum("DOWN", "UP", "RIGHT" ,"LEFT")
    self.current_direction = self.DIRECTION.DOWN

    self.bounce_count = -1

    self.dir_normal = {}
    self:_set_direction(false)

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyBounceLogic:update(dt)
    self.flashing:update(dt)

    if self.state == self.STATES.BOUNCE then
        self.entity.x = self.entity.x + self.dir_normal.x * self.move_speed
        self.entity.y = self.entity.y + self.dir_normal.y * self.move_speed
    elseif self.state == self.STATES.ANTICIPATION then
        self.state_count = self.state_count - 1

        if self.state_count == 0 then
            self.state = self.STATES.BOUNCE
        end
    end

    if self.bounce_count <= self.bounces or self.inf_bounces then
        if self.entity.y > CONFIG.GAME.VIEWPORT.H - 16 then
            self.entity.y = CONFIG.GAME.VIEWPORT.H - 16
            self.current_direction = self.DIRECTION.UP
            self:_set_direction(true)
        elseif self.entity.y < 0 and self.bounce_count ~= 0 then
            self.entity.y = 0
            self.current_direction = self.DIRECTION.DOWN
            self:_set_direction(true)
        elseif self.entity.x < 0 then
            self.entity.x = 0
            self.current_direction = self.DIRECTION.RIGHT
            self:_set_direction(true)
            self.entity.game_logic.camera:shake(1, 15)
            DATA.SFX[DATA.SFX.INDEX.BOUNCE]:play()
        elseif self.entity.x > CONFIG.GAME.VIEWPORT.W - 16 then
            self.entity.x = CONFIG.GAME.VIEWPORT.W - 16
            self.current_direction = self.DIRECTION.LEFT
            self:_set_direction(true)
        end
    end

    if FRAME % 5 == 0 then
        PARTICLE_FACTORY.bounce(
            self.entity.game_logic.particle_handler,
            self.entity.x + 8 - 1, self.entity.y + 8 - 1
        )
    end

    if self.entity.x < -16 or self.entity.x > CONFIG.GAME.VIEWPORT.W or
    self.entity.y < -16 or self.entity.y >CONFIG.GAME.VIEWPORT.H then
        self.entity.delete = true
    end
end

function EnemyBounceLogic:_set_direction(isNotFirstBounce)
    self.bounce_count = self.bounce_count + 1

    local sign = lazy.util.fif(math.random() < 0.5, 1, -1)

    local mod_angle = sign * math.random(ANGLE_RANGE_MIN, ANGLE_RANGE_MAX)

    if self.current_direction == self.DIRECTION.DOWN then
        self.dir_normal = lazy.math.normalAngleDegree(90 + mod_angle)
    elseif self.current_direction == self.DIRECTION.UP then
        self.dir_normal = lazy.math.normalAngleDegree(270 + mod_angle)
    elseif self.current_direction == self.DIRECTION.RIGHT then
        self.dir_normal = lazy.math.normalAngleDegree(0 + mod_angle)
    elseif self.current_direction == self.DIRECTION.LEFT then
        self.dir_normal = lazy.math.normalAngleDegree(180 + mod_angle)
    end

    self.state = self.STATES.ANTICIPATION
    self.state_count = CONFIG.ENEMY.BOUNCE.BOUNCE_COOLDOWN

    if isNotFirstBounce then
        self.entity.game_logic.camera:shake(1, 5)
        DATA.SFX[DATA.SFX.INDEX.BOUNCE]:play()
    end
end