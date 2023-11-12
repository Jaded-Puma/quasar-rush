EnemyMedusaLogic = lazy.extend("EnemyMedusaLogic", EnemyBaseLogic)

local PI2 = 2 * math.pi
local PHI = 1.618033988749


function EnemyMedusaLogic:constructor(entity)
    self.entity = entity

    self.flashing = Flashing()

    local config = self.entity.config
    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.mode = config[5]
    self.parts = config[6]

    -- update logic
    self.hp = self.hp_mod
    self.move_speed = self.move_speed_mod

    self.damage = CONFIG.ENEMY.MEDUSA.DAMAGE_COLLISION
    self.wait = 0

    -- self.strech = PI2 * 3.2
    self.strech = CONFIG.GAME.VIEWPORT.W
    self.base_y = (CONFIG.GAME.VIEWPORT.H - 2) - CONFIG.ENEMY.MEDUSA.AMP

    self.start_angle = 0
    
    self.acc = 0
    self.jerk = 0

    if self.mode == 5 then
        self.mode = math.random(1, 2)
    elseif self.mode == 6 then
        self.mode = math.random(3, 4)
    elseif self.mode == 7 then
        
    end

    if self.mode == 1 or self.mode == 2 then
        self.start_angle = PI2 * math.random()
    elseif self.mode == 3 then
        self.start_angle = 0.3 * math.random()  * lazy.math.random_sign()
    elseif self.mode == 4 then
        self.start_angle = 0.3 * math.random()  * lazy.math.random_sign()
    elseif self.mode == 7 then
        self.start_angle = 5/4 * math.pi
        self.angle = self.start_angle
        self.angle_step = -1/(60*6) * PI2
        self.base_x = self.entity.game_logic.spaceship.x
        self.base_y = 0
        self.base_i = 0
        self.wait = 0
    elseif self.mode == 8 then
        self.jerk = 0.0001
        self.acc = 0.0
    elseif self.mode == 9 then
        self.jerk = 0.00012
        self.acc = 0.0 --  0.0065
        self.move_speed = 0.23
    elseif self.mode == 10 then
        self.base_x = CONFIG.GAME.VIEWPORT.W / 2 - 8
    elseif self.mode == 11 then
        self.start_angle = -math.pi + 1/16*math.pi * math.random() * lazy.math.random_sign()
    elseif self.mode == 12 then
        self.start_angle = 0
    end

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyMedusaLogic:update(dt)
    self.flashing:update(dt)

    local mode = self.mode
    if mode == 7 then
        if self.wait ~= 0 then
            self.wait = self.wait - 1

            if self.wait == 0 then
                self.flashing:start()
                self.angle = self.start_angle + 1/PHI*self.base_i
            end
        else
            self.angle = self.angle + self.angle_step
        end

        local th = self.angle

        local r = 48 + (self.wait == 0 and (self.base_i * 7/10 ) or 0)
 
        local a = 0.01 + (math.abs(self.base_x - self.entity.game_logic.spaceship.x)/64) * 0.01
        a = lazy.math.bound(a, 0 , 1)
        self.base_x = lazy.math.lerp(a, self.base_x, self.entity.game_logic.spaceship.x)

        --self.base_x =  lazy.math.nlerp(lazy.tween.func.easeOutCubic, self.base_x, self.entity.game_logic.spaceship.x, self.base_x)

        local x = self.entity.game_logic.spaceship.x
        local y = self.entity.game_logic.spaceship.y - 8

        self.entity.x = self.base_x + r * math.cos(th) 
        self.entity.y = y + r * math.sin(th)

    elseif mode == 10 then
        local theta = self.start_angle + (self.entity.y + 8) / CONFIG.GAME.VIEWPORT.H
        local th = PI2 * 1.5 * (theta - 0.5)
        local hsum = 104 * self.spawn_dir * math.cos(th)

        -- x and y
        self.entity.x = self.base_x + hsum
        self.entity.y = self.entity.y + self.move_speed
    else
        self.entity.x = self.entity.x + self.spawn_dir * self.move_speed
        local theta = self.start_angle + ((self.entity.x + 8) / self.strech) - 0.5
        local hsum = 1
        local offset = 0

        -- basic sin movement
        if mode == 1 then
            local th = PI2 * 1.5 * theta
            local h1 = math.cos(th)

            hsum = h1
        -- square wave movement
        elseif mode == 2 then
            local th = PI2 * 1.3 * theta

            local h1 = math.sin(th)
            local h2 = math.sin(3 * th) / 3
            local h3 = math.sin(5 * th) / 5
            hsum = (h1 + h2 + h3) - 0.1
        --- versin x
        elseif mode == 3 then
            local th = PI2 * 3 * theta
            local h1 = (math.sin(th) / (th)) - 0.7

            hsum = 2.5 * h1
        --- 1 - versin x
        elseif mode == 4 then
            local th = PI2 * 2.3 * theta
            local h1 = -(math.sin(th) / (th) - 0.30)
            offset = 0 -- -24

            hsum = 1.4 * h1
        -- wall
        elseif mode == 8 then
            local th = PI2 * theta^2

            self.acc = self.acc + self.jerk
            self.move_speed = lazy.math.upper_bound(self.move_speed + self.acc, 3.5)

            local amp = math.cos(0.6 * th)
            hsum = 1 * amp * -math.cos(1.9 * th)

        -- 2x sin
        elseif mode == 9 then
            local amp = 1.3
            local th = PI2 * 1.25 * theta

            if self.even then
                hsum = amp * math.cos(th)
            else
                hsum = amp * math.cos(math.pi + th)
            end

            self.acc = self.acc + self.jerk
            self.move_speed = lazy.math.upper_bound(self.move_speed + self.acc, 1.7)
        -- helix
        elseif mode == 11 then
            local amp = 1.2
            local th = PI2 * 1.8 * theta
            offset = -24

            if self.even then
                hsum = amp * math.cos(th)
            else
                hsum = amp * math.cos(0.36*math.pi + th)
            end
        -- opposite sin
        elseif mode == 12 then
            local th = PI2 * 1.25 * theta

            local amp = 1.2 * math.cos(0.4 * th)

            if self.even then
                hsum = amp * math.cos(th)
            else
                hsum = amp * math.cos(math.pi + th)
            end
        end

        self.entity.y = self.base_y + CONFIG.ENEMY.MEDUSA.AMP * hsum + offset
    end

    -- cehck for delete
    if mode == 7 then
        -- no deletion
    elseif mode == 10 then
        if self.entity.y > CONFIG.GAME.VIEWPORT.H then
            self.entity.delete = true
        end
    else
        if self.spawn_dir > 0 
        and self.entity.x > CONFIG.GAME.VIEWPORT.W then
            self.entity.delete = true
        elseif self.spawn_dir < 0 
        and self.entity.x <  -16 then
            self.entity.delete = true
        end
    end
end