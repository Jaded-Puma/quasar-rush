EnemyBounce = lazy.extend("EnemyBounce", EnemyBase)

local SPAWN_X_BUFFER = 16

function EnemyBounce:constructor(game_logic, config)
    EnemyBounce.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16, 16
    )

    self.logic = EnemyBounceLogic(self)
    self.renderer = EnemyBounceRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(6, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyBounce:update(dt)
    self.logic:update(dt)
end

function EnemyBounce:render()
    self.renderer:render()
end

function EnemyBounce:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    self.logic.spawn_dir = lazy.math.sign((math.random() * 2) - 1)

    self.x = math.random(SPAWN_X_BUFFER, CONFIG.GAME.VIEWPORT.W - SPAWN_X_BUFFER)
    self.y = -16

    local hitbox = CONFIG.ENEMY.BOUNCE.HITBOX
    self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    enemy_handler:add(self)
end