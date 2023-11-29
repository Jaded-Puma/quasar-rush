EnemyZombieShipLogic = lazy.extend("EnemyZombieShipLogic", EnemyBaseLogic)

local MIN_KAMEKAZE_Y = 10
local MAX_KAMEKAZE_Y = 42

local MAX_WAIT = 70

local CHARGE_ACC = 0.1

local States = lazy.enum("MOVE", "WAIT", "CHARGE")

function EnemyZombieShipLogic:constructor(entity)
    self.entity = entity

    self.flashing = Flashing()

    local config = self.entity.config

    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.size = config[5]
    self.spawn_mode = config[6]

    self.kamikaze = config[7]

    self.hp = self.hp_mod
    self.move_speed = self.move_speed_mod

    local damage_size = (self.size > 1) and CONFIG.ENEMY.ZOMBIE_SHIP.DAMAGE_SIZE_2 or 0

    self.damage = CONFIG.ENEMY.ZOMBIE_SHIP.DAMAGE_COLLISION + damage_size

    self.state = States.MOVE
    self.kamikaze_y = MIN_KAMEKAZE_Y + math.random(0, MAX_KAMEKAZE_Y - MIN_KAMEKAZE_Y)

    self.wait = MAX_WAIT

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyZombieShipLogic:update(dt)
    if self.state == States.MOVE then
        self.entity.y = self.entity.y + self.move_speed

        if self.kamikaze and self.entity.y > self.kamikaze_y then
            self.state = States.WAIT
            self.wait = MAX_WAIT
        end
    elseif self.state == States.WAIT then
        self.wait = self.wait - 1

        if self.wait == 0 then
            self.state = States.CHARGE
        end
    elseif self.state == States.CHARGE then
        self.entity.y = self.entity.y + self.move_speed
        self.move_speed = self.move_speed + CHARGE_ACC
    end
    

    if self.state == States.CHARGE
    and FRAME % 2 == 0 then
      PARTICLE_FACTORY.aim_attack_trail(
          self.entity.game_logic.particle_handler,
          self.entity.x + 8 - 1, self.entity.y + 8 - 1
      )
  end

    self.flashing:update(dt)

    if self.entity.y > CONFIG.GAME.VIEWPORT.H + (self.size - 1) * 16 then
        self.entity.delete = true
    end
end

function EnemyZombieShipLogic:kill()
    self.entity.delete = true

    self.entity.game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + self.entity.h / 2)

    if self.size == 2 then
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y, DATA.GFX.EXPLOSION))
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x + 16, self.entity.y, DATA.GFX.EXPLOSION))
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y + 16, DATA.GFX.EXPLOSION))
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x + 16, self.entity.y + 16, DATA.GFX.EXPLOSION))
    else
        self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y, DATA.GFX.EXPLOSION))
    end

    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(self.entity.game_logic.camera)
end