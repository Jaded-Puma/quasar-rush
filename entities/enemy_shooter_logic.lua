EnemyShooterLogic = lazy.extend("EnemyShooterLogic", EnemyBaseLogic)

function EnemyShooterLogic:constructor(entity)
    self.STATES = lazy.enum("MOVE", "ANTICIPATION", "SHOOT", "COOLDOWN")
    self.state = self.STATES.MOVE

    self.entity = entity

    self.flashing = Flashing()

    local config = self.entity.config
    self.hp_mod = config[1]
    self.move_speed_mod = config[2]
    self.use_alt_pal = config[3]
    self.pal_mode = config[4]

    self.mode = config[5]
    self.attack_timeout_mod  = config[6]
    self.projectile_speed_mod = config[7]
    self.shots_max = config[8]

    -- update logic
    self.hp = self.hp_mod
    self.move_speed = self.move_speed_mod
    self.attack_time_max = self.attack_timeout_mod
    self.attack_timer = math.random(1, self.attack_time_max)

    self.projectile_damage = CONFIG.ENEMY.SHOOTER.DAMAGE_PROJECTILE

    self.player = {x = -16, y = -16}

    self.shoots_total = 0
    self.shoot_buffer_count = 0


    self.normal_direction_vec = {}

    self.shoot_cooldown_count = 0
    self.shoot_anticipation_count = 0

    self.state_count = 0

    -- hard mode
    self.entity:setup_hardmode(self)
end

function EnemyShooterLogic:update(dt)
    self.flashing:update(dt)

    if self.state == self.STATES.MOVE then
        self.entity.x = self.entity.x + self.spawn_dir * self.move_speed

        if self.entity.x > 0 and self.entity.x < CONFIG.GAME.VIEWPORT.W - 16 then
            if self.attack_timer == 0 then
                self.state = self.STATES.ANTICIPATION
                self.state_count = CONFIG.ENEMY.SHOOTER.SHOOT_ANTICIPATION
            else
                self.attack_timer = self.attack_timer - 1
            end
        end
    elseif self.state == self.STATES.ANTICIPATION then
        self.state_count = self.state_count - 1

        if self.state_count == 0 then
            self.state = self.STATES.SHOOT
            self.shoot_buffer_count = CONFIG.ENEMY.SHOOTER.SHOOT_BUFFER
            self.shoots_total = self.shots_max
        end
    elseif self.state == self.STATES.SHOOT then
        if self.shoot_buffer_count == 0 then
            self.shoot_buffer_count = CONFIG.ENEMY.SHOOTER.SHOOT_BUFFER
            self.shoots_total = self.shoots_total - 1
            self:_fire_weapon()
        else
            self.shoot_buffer_count = self.shoot_buffer_count - 1
        end

        if self.shoots_total == 0 then
            self.state = self.STATES.COOLDOWN
            self.state_count = CONFIG.ENEMY.SHOOTER.SHOOT_COOLDOWN
        end
    elseif self.state == self.STATES.COOLDOWN then
        self.state_count = self.state_count - 1

        if self.state_count == 0 then
            self.state = self.STATES.MOVE
            self.attack_timer = self.attack_time_max
        end
    end

    if self.entity.x < -16 or self.entity.x > CONFIG.GAME.VIEWPORT.W + 16 then
        self.entity.delete = true
    end
end

function EnemyShooterLogic:_fire_weapon()
    local x_offset = 8 - 2
    local y = 13

    local pos_x, pos_y = self.entity.x + x_offset, self.entity.y + y - 2

    -- handler, x, y, w, h, normal, speed, acc, update_func, mod_animate)

    if self.mode == 1 then
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            pos_x, pos_y,
            4, 5,
            CONFIG.ENEMY.SHOOTER.MODE1_PROJ_NORMAL,
            self.projectile_speed_mod,
            0,
            nil,
            self.entity.game_logic.projectile_enemy_shooter_anim
        )
    elseif self.mode == 2 then
        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            pos_x, pos_y,
            4, 5,
            CONFIG.ENEMY.SHOOTER.MODE2_PROJ_NORMAL1,
            self.projectile_speed_mod,
            0,
            nil,
            self.entity.game_logic.projectile_enemy_shooter_anim
        )

        self.entity.game_logic:spawn_projectile(
            self.entity,
            self.entity.game_logic.enemy_projectile_handler,
            pos_x, pos_y,
            4, 5,
            CONFIG.ENEMY.SHOOTER.MODE2_PROJ_NORMAL2,
            self.projectile_speed_mod,
            0,
            nil,
            self.entity.game_logic.projectile_enemy_shooter_anim
        )
    end

    DATA.SFX[DATA.SFX.INDEX.ENEMY_BULLET]:play()
end
