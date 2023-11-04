EnemyPeekLogic = lazy.extend("EnemyPeekLogic", EnemyBaseLogic)

local PEEK_MIN = CONFIG.GAME.VIEWPORT.H - CONFIG.SPACESHIP.Y - 8
local PEEK_Y_VARIATION = 32

function EnemyPeekLogic:constructor(entity)
    self.entity = entity

    self.STATES = lazy.enum("PEEK_IN", "WAIT", "HOLD")
    self.state = self.STATES.PEEK_IN

    self.flashing = Flashing()

    local config = self.entity.config
    self.hp_mod = config[1]
    self.peek_timeout_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.peek_amount_mod = config[5]
    self.spawn_mode = config[6]

    -- update logic
    self.hp = self.hp_mod
    self.peek_time_max = self.peek_timeout_mod
    self.peek_time = self.peek_time_max
    self.peek_amount = CONFIG.ENEMY.PEEK.PEEK_AMOUNT + self.peek_amount_mod - math.random(0, PEEK_Y_VARIATION)

    self.peek_amount = lazy.math.lower_bound(self.peek_amount, PEEK_MIN)

    self.a = 0
    self.base_y = -16
    self.attack_y = 0

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyPeekLogic:update(dt)
    self.flashing:update(dt)
    local spaceship = self.entity.game_logic.spaceship

    if (self.state == self.STATES.PEEK_IN or self.state == self.STATES.WAIT)
    and self.entity.y > spaceship.y + CONFIG.SPACESHIP.HITBOX.Y + CONFIG.SPACESHIP.HITBOX.H
    and (spaceship.x + 16 > self.entity.x and spaceship.x < self.entity.x + 16)
    then
        self.state = self.STATES.WAIT
    elseif self.state == self.STATES.WAIT then
        self.state = self.STATES.PEEK_IN
    end

    if self.state == self.STATES.PEEK_IN then
        self.peek_time = self.peek_time - 1

        self.a = 1 - self.peek_time / self.peek_time_max
        self.entity.y = self.base_y - lazy.math.lerp(self.a, 0, self.peek_amount)

        if self.peek_time == 0 then
            self.state = self.STATES.HOLD
        end
    elseif self.state == self.STATES.HOLD then

    end
end

function EnemyPeekLogic:kill()
    self.entity.delete = true

    local parts_count = math.ceil((self.peek_amount - 16) / 16)

    for i = 0, parts_count do
        local y = self.entity.y + i * 16
        self.entity.game_logic:particle_explosion(self.entity.x + self.entity.w / 2, y + self.entity.h / 2)
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, y, DATA.GFX.EXPLOSION))
    end

    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(self.entity.game_logic.camera)
end