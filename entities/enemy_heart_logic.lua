EnemyHeartLogic = lazy.extend("EnemyHeartLogic", EnemyBaseLogic)

local PI2 = 2 * math.pi

local ATTACK_ACC = 0.0001

local ANTICIPATION_TIMEOUT_MAX = 30
local COOLDOWN_TIMEOUT_MAX = 120
local IDLE_TIMEOUT_MAX = 120 --250
local ATTACK_TIMEOUT_MAX = 400

local BASE_PROJECTILE_SPEED = 0.4

local BASE_ROTATION_SPEED = PI2 / (60 * 3)

function EnemyHeartLogic:constructor(entity)
    self.entity = entity
    self.flashing = Flashing()

    self.STATES = lazy.enum("TRANS_IN", "IDLE", "ANTICIPATION", "ATTACK", "COOLDOWN", "TRANS_OUT")
    self.state = self.STATES.TRANS_IN

    local config = self.entity.config
    self.hp_mod = -1

    self.attack_pos = lazy.util.position(14, 15)
    self.attack_angle = 0

    
    self.attack_type = 0

    self.theta_acc = 0
    self.speed = 0

    self.frame = 10
    self.lane_splits = 0
    self.rotation_speed = 0
    self.rotation_acc = 0
    self.projectile_acc = 0
    self.projectile_speed = 0
    self.projectile_speed_mul = 0 -- ! deprecated
    self.rotations = 0
    self.revered_rotations = false
    self.degree_per_rotation = 0 --- ! deprecated
    self.degree_angle_mul = 0

    self.projectile_damage = CONFIG.ENEMY.HEART.DAMAGE_PROJECTILE

    self._state_timeout = CONFIG.ENEMY.HEART.TRANS_TIME

    -- update logic
    self.hp = 10000000
end

function EnemyHeartLogic:update(dt)
    self.flashing:update(dt)

    if self.state == self.STATES.TRANS_IN then
        self.base_y = self.entity.y

        if self._state_timeout == 0 then
            self.state = self.STATES.IDLE
            self._state_timeout = IDLE_TIMEOUT_MAX + 60
        end
    elseif self.state == self.STATES.TRANS_OUT then
        if self._state_timeout == 0 then
            self.entity.delete = true
        end
    elseif self.state == self.STATES.IDLE then
        self.entity.y = self.base_y + lazy.math.round(math.sin(PI2 * FRAME / 180))

        if self._state_timeout == 0 then
            self.entity.y = self.base_y

            self.state = self.STATES.ANTICIPATION
            self._state_timeout = ANTICIPATION_TIMEOUT_MAX
        end
    elseif self.state == self.STATES.ANTICIPATION then
        if self._state_timeout == 0 then
            self:_select_attack()
        end
    elseif self.state == self.STATES.ATTACK then
        --local theta_0 = math.deg(-self.attack_angle)

        if FRAME % self.frame == 0 then
            self.projectile_speed = self.projectile_speed + self.projectile_acc

            local x = self.entity.x + self.attack_pos.x
            local y = self.entity.y + self.attack_pos.y

            -- self.rotations = 0
            -- self.revered_rotations = false
            -- self.degree_per_rotation = 0

            local a_amount = 360 / self.lane_splits

            for i = 0, self.rotations - 1 do
                -- TODOL requires array to track rotations
            end

            for i = 0, self.lane_splits - 1 do
                local angle = i * a_amount


                local theta = math.deg(self.attack_angle)
                local normal = lazy.math.normalAngleDegree(theta + angle)
                self:_fire_projectile(x, y, normal, self.projectile_speed)

                if self.revered_rotations then
                    theta = math.deg(-self.attack_angle)
                    normal = lazy.math.normalAngleDegree(theta + angle)
                    self:_fire_projectile(x, y, normal, self.projectile_speed)
                end
            end

            self.attack_angle = self.attack_angle + self.rotation_speed * (1 + self.theta_acc)
            self.theta_acc = self.theta_acc + self.rotation_acc
        end
        


        if self._state_timeout == 0 then
            self.state = self.STATES.COOLDOWN
            self._state_timeout = COOLDOWN_TIMEOUT_MAX
        end
    elseif self.state == self.STATES.COOLDOWN then
        if self._state_timeout == 0 then
            self.state = self.STATES.IDLE
            self._state_timeout = IDLE_TIMEOUT_MAX
        end
    end

    if self._state_timeout ~= 0 then
        self._state_timeout = self._state_timeout - 1
    end
end


function EnemyHeartLogic:_fire_projectile(x, y, normal, speed)
    self.entity.game_logic:spawn_projectile(
        self.entity,
        self.entity.game_logic.enemy_projectile_handler,
        x, y,
        5, 5,
        normal,
        speed,
        0,
        nil,
        self.entity.game_logic.projectile_enemy_organic_anim,
        2
    )
end

function EnemyHeartLogic:_select_attack()
    -- cleanup
    self.theta_acc = 0
    self.attack_angle = 0
    self.speed = 0


    self.attack_type = math.random(1, 5)

    -- self.attack_type = 5

    --- ? 0 is debug attack
    if self.attack_type == 0 then
        self.frame = 11
        self.lane_splits = 14
        self.rotation_speed = - BASE_ROTATION_SPEED * 0.3
        self.rotation_acc = 0
        self.projectile_acc = 0
        self.projectile_speed = BASE_PROJECTILE_SPEED - 0.1
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = false
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX + 400
    elseif self.attack_type == 1 then
        self.frame = 40
        self.lane_splits = 8
        self.rotation_acc = 0.7
        self.rotation_speed = BASE_ROTATION_SPEED
        self.projectile_acc = 0
        self.projectile_speed = BASE_PROJECTILE_SPEED
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = false
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX
    elseif self.attack_type == 2 then
        self.frame = 20
        self.lane_splits = 9
        self.rotation_speed = BASE_ROTATION_SPEED
        self.rotation_acc = 0
        self.projectile_acc = 0.2
        self.projectile_speed = BASE_PROJECTILE_SPEED
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = false
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX

    elseif self.attack_type == 3 then
        self.frame = 60
        self.lane_splits = 5
        self.rotation_speed = BASE_ROTATION_SPEED * 1.5
        self.rotation_acc = 0
        self.projectile_acc = 0
        self.projectile_speed = BASE_PROJECTILE_SPEED
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = true
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX + 400
    elseif self.attack_type == 4 then
        self.frame = 16
        self.lane_splits = 2
        self.rotation_speed = BASE_ROTATION_SPEED * 0.4
        self.rotation_acc = 0.8
        self.projectile_acc = 0.085
        self.projectile_speed = BASE_PROJECTILE_SPEED + 0.9
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = false
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX + 200

    elseif self.attack_type == 5 then

        self.frame = 17
        self.lane_splits = 11
        self.rotation_speed = - BASE_ROTATION_SPEED * 0.3
        self.rotation_acc = 0
        self.projectile_acc = 0
        self.projectile_speed = BASE_PROJECTILE_SPEED - 0.1
        --self.projectile_speed_mul = 0
        self.rotations = 0
        self.revered_rotations = false
        --self.degree_per_rotation = 0
        self.degree_angle_mul = 0

        self._state_timeout = ATTACK_TIMEOUT_MAX + 400
    end


    
    self.state = self.STATES.ATTACK
end

function EnemyHeartLogic:kill()
    self.state = self.STATES.TRANS_OUT
    self._state_timeout = CONFIG.ENEMY.HEART.TRANS_TIME
end