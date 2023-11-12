SpaceshipEntityLogic = lazy.class("SpaceshipEntityLogic")

function SpaceshipEntityLogic:constructor(entity)
    self.entity = entity

    self.max_hp = CONFIG.SPACESHIP.HP
    self.hp = self.max_hp

    self.max_exp = CONFIG.SPACESHIP.EXP
    self.exp = 0
    self.level = 0

    self.flashing = Flashing()

    self.attack_timeout_mod = 0
    self.weapons = 1
    self.weapon_recharge_count = 3
    self.projectile_speed_mod = 0

    self.enable_rocket = false
end

function SpaceshipEntityLogic:update(dt)
    self.flashing:update(dt)

    self.entity.x = self.entity.game_logic.control_ball.x

    if self.weapon_recharge_count == 0 then

        self.weapon_recharge_count = CONFIG.SPACESHIP.WEAPON_RECHARGE + self.attack_timeout_mod

        if self.weapons <= 2 then
            self:_fire_weapon(1, CONFIG.SPACESHIP.PROJECTILE_NORMAL_WEAPON1_LANE1)
        end

        if self.weapons >= 2 then
            self:_fire_weapon(2, CONFIG.SPACESHIP.PROJECTILE_NORMAL_WEAPON2_LANE1)
            self:_fire_weapon(2, CONFIG.SPACESHIP.PROJECTILE_NORMAL_WEAPON2_LANE2)
        end

        if self.weapons >= 3 then
            self:_fire_weapon(3, CONFIG.SPACESHIP.PROJECTILE_NORMAL_UP)
        end

        DATA.SFX[DATA.SFX.INDEX.BULLET_FIRE]:play()
    else
        self.weapon_recharge_count = self.weapon_recharge_count - 1
    end

    if FRAME % 30 == 0 and self.weapons >= 4 then
        self:_fire_weapon(4, CONFIG.SPACESHIP.PROJECTILE_NORMAL_WEAPON1_LANE1)
    end
    if FRAME % 30 == 0 and self.weapons >= 5 then
        self:_fire_weapon(5, CONFIG.SPACESHIP.PROJECTILE_NORMAL_WEAPON1_LANE1)
    end

    local mod = CONFIG.SPACESHIP.PROJECTILE_ROCKET_TIME_MOD 
      - CONFIG.SPACESHIP.PROJECTILE_ROCKET_TIME_MOD_SUB * self.entity.game_logic.wave

    if FRAME % mod == 0 
      and self.enable_rocket
      and self.entity.game_logic.state == self.entity.game_logic.STATES.GAME
      then
        local anim = self.entity.game_logic.projectile_spaceship_anim_rocket
        
        local normal = CONFIG.SPACESHIP.PROJECTILE_NORMAL_ROCKET

        local acc = CONFIG.SPACESHIP.PROJECTILE_ROCKET_ACC
        local speed = CONFIG.SPACESHIP.PROJECTILE_ROCKET_SPEED
        
        local x, y = self.entity.x + 5, self.entity.y + 6

        local update = function (this)
            if this.entity.y < CONFIG.SPACESHIP.Y - 10 then
                -- this.entity.x = this.entity.x + this.speed * this.normal.x
                this.entity.y = this.entity.y + this.speed * this.normal.y
            else
                this.entity.x = self.entity.x + 5
                this.entity.y = this.entity.y + this.speed * this.normal.y

                this.explode = true
            end
            
            -- apply acc
            this.speed = this.speed + this.acc
        end

        -- (game_logic, x, y, w, h, normal, speed, acc, update_func, mod_animate)
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            x, y,
            4, 8,
            normal,
            speed,
            acc,
            update,
            anim
        )

        DATA.SFX[DATA.SFX.INDEX.ROCKET_READY]:play()
    end
end

function SpaceshipEntityLogic:addExp()
    self.entity.game_logic.score = self.entity.game_logic.score + CONFIG.GLOBAL.SCORE.EXP_ORB

    self.exp = lazy.math.upper_bound(self.exp + CONFIG.SPACESHIP.EXP_PER_CAPSULE, CONFIG.SPACESHIP.EXP)
end

function SpaceshipEntityLogic:addLevel()
    self.entity.game_logic.score = self.entity.game_logic.score + CONFIG.GLOBAL.SCORE.EXP_MAX_ORB

    self.exp = lazy.math.upper_bound(self.exp + CONFIG.SPACESHIP.EXP, CONFIG.SPACESHIP.EXP)
end

function SpaceshipEntityLogic:addHealth()
    self.hp = lazy.math.upper_bound(self.hp + CONFIG.GLOBAL.DROP_HEART_HEALTH, CONFIG.SPACESHIP.HP)
end

function SpaceshipEntityLogic:getHpPercent()
    return self.hp / self.max_hp
end

function SpaceshipEntityLogic:getExpPercent()
    return self.exp / self.max_exp
end

function SpaceshipEntityLogic:checkLevelUp()
    if self.exp == CONFIG.SPACESHIP.EXP
    and self.level < CONFIG.SPACESHIP.MAX_LEVEL then
        DATA.SFX[DATA.SFX.INDEX.LEVELUP]:play()

        self.exp = 0
        self.level = self.level + 1

        return true
    else
        return false
    end
end

function SpaceshipEntityLogic:_fire_weapon(weapon_type, normal)
    local speed = CONFIG.SPACESHIP.PROJECTILE_SPEED + self.projectile_speed_mod
    speed = lazy.math.upper_bound(speed, 13)

    local anim = self.entity.game_logic.projectile_spaceship_anim_base
    local x, y = 0, 0
    if weapon_type == 4 or weapon_type == 5 then
        anim = self.entity.game_logic.projectile_spaceship_anim_sin
        speed = CONFIG.SPACESHIP.PROJECTILE_SIN_SPEED
    end

    if weapon_type == 3 then
        x = self.entity.x + 8
        y = CONFIG.SPACESHIP.Y + 7
        local x0, x1 = x - 7 - 2, x + 7 - 2

        -- handler, x, y, w, h, normal, speed, acc, update_func, mod_animate)
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            x0, y,
            4, 4,
            normal,
            speed,
            0,
            nil,
            anim
        )
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            x1, y,
            4, 4,
            normal,
            speed,
            0,
            nil,
            anim
        )
    elseif weapon_type == 4 then
        local update_func = function (self)
            self.angle = self.angle + (math.pi * 2 / 30)

            self.entity.y = self.entity.y + self.speed * self.normal.y
            self.entity.x = self.base_x + 20 * math.sin(self.angle)
        end

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            self.entity.x + 8 - 2, CONFIG.SPACESHIP.Y + 8,
            4, 4,
            normal,
            speed,
            0,
            update_func,
            anim
        )
    elseif weapon_type == 5 then
        local update_func = function (self)
            self.angle = self.angle + (math.pi * 2 / 30)

            self.entity.y = self.entity.y + self.speed * self.normal.y
            self.entity.x = self.base_x + 20 * math.sin(math.pi + self.angle)
        end

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            self.entity.x + 8 - 2, CONFIG.SPACESHIP.Y + 8,
            4, 4,
            normal,
            speed,
            0,
            update_func,
            anim
        )
    else
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.projectile_handler,
            self.entity.x + 8 - 2, CONFIG.SPACESHIP.Y + 8,
            4, 4,
            normal,
            speed,
            0,
            nil,
            anim
        )
    end
end


