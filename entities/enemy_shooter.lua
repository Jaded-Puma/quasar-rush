EnemyShooter = lazy.extend("EnemyShooter", EnemyBase)

local SPAWN_DIR_TRACKER = true

function EnemyShooter:constructor(game_logic, config)
    EnemyShooter.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16 , 16
    )

    self.logic = EnemyShooterLogic(self)
    self.renderer = EnemyShooterRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(2, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyShooter:update(dt)
    self.logic:update(dt)
end

function EnemyShooter:render()
    self.renderer:render()
end

function EnemyShooter:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    for i = 1, 6 do
        -- self.logic.spawn_dir = lazy.math.sign((math.random() * 2) - 1)

        if SPAWN_DIR_TRACKER then
            self.logic.spawn_dir = 1
        else
            self.logic.spawn_dir = -1
        end
        SPAWN_DIR_TRACKER = not SPAWN_DIR_TRACKER

        local x = 0
        if self.logic.spawn_dir > 0 then
            x = -16
        else
            x = CONFIG.GAME.VIEWPORT.W + 16
        end
        local y = math.random(CONFIG.ENEMY.SHOOTER.SPAWN_HEIGHT_MIN, CONFIG.ENEMY.SHOOTER.SPAWN_HEIGHT_MAX)
        local w = 16
        local h = 16

        local isColliding = false
        enemy_handler:loop(
            function(e)
                if not e:typeof(EnemyShooter) then return end

                if lazy.util.is_box_inside_box(x, y, w, h, e.x, e.y, e.w, e.h) then
                    isColliding = true
                end
            end
        )

        if not isColliding then
            self.x = x
            self.y = y
            local hitbox = CONFIG.ENEMY.SHOOTER.HITBOX
            self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
            enemy_handler:add(self)
            break
        end
    end
end