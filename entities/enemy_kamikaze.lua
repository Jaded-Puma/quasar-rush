EnemyKamikaze = lazy.extend("EnemyKamikaze", EnemyBase)

local SPAWN_DIR_TRACKER = true

function EnemyKamikaze:constructor(game_logic, config)
    EnemyKamikaze.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16, 16
    )

    self.logic = EnemyKamikazeLogic(self)
    self.renderer = EnemyKamikazeRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(4, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyKamikaze:update(dt)
    self.logic:update(dt)
end

function EnemyKamikaze:render()
    self.renderer:render()
end

function EnemyKamikaze:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    self.y = math.random(CONFIG.ENEMY.KAMIKAZE.SPAWN_HEIGHT_MIN, CONFIG.ENEMY.KAMIKAZE.SPAWN_HEIGHT_MAX)

    -- self.logic.spawn_dir = lazy.math.sign((math.random() * 2) - 1)
    if SPAWN_DIR_TRACKER then
        self.logic.spawn_dir = 1
    else
        self.logic.spawn_dir = -1
    end
    SPAWN_DIR_TRACKER = not SPAWN_DIR_TRACKER

    if self.logic.spawn_dir > 0 then
        self.x = -16
        
    else
        self.x = CONFIG.GAME.VIEWPORT.W
    end

    local hitbox = CONFIG.ENEMY.KAMIKAZE.HITBOX
    self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    enemy_handler:add(self)
end