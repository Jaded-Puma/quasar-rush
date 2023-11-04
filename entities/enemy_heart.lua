EnemyHeart = lazy.extend("EnemyHeart", EnemyBase)

function EnemyHeart:constructor(game_logic, config)
    EnemyHeart.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        32, 32
    )

    self.logic = EnemyHeartLogic(self)
    self.renderer = EnemyHeartRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(1, false, 1)
end

function EnemyHeart:update(dt)
    self.logic:update(dt)
end

function EnemyHeart:render()
    self.renderer:render()
end

function EnemyHeart:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    self.x = CONFIG.GAME.VIEWPORT.W / 2 - 16
    self.y = CONFIG.GAME.VIEWPORT.H / 3 - 16

    local hitbox = CONFIG.ENEMY.HEART.HITBOX
    self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    enemy_handler:add(self)
end