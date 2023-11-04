EnemyOrganic = lazy.extend("EnemyOrganic", EnemyBase)

function EnemyOrganic:constructor(game_logic, config)
    EnemyOrganic.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16, 16
    )

    self.logic = EnemyOrganicLogic(self)
    self.renderer = EnemyOrganicRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(7, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyOrganic:update(dt)
    self.logic:update(dt)
end

function EnemyOrganic:render()
    self.renderer:render()
end

function EnemyOrganic:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    if SPAWN_DIR_TRACKER then
        self.logic.spawn_dir = 1
    else
        self.logic.spawn_dir = -1
    end
    SPAWN_DIR_TRACKER = not SPAWN_DIR_TRACKER

    if self.logic.spawn_dir > 0 then
        self.x = -16
        self.y = 0
    else
        self.x = CONFIG.GAME.VIEWPORT.W
        self.y = 0
    end

    local hitbox = CONFIG.ENEMY.ORGANIC.HITBOX
    self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    enemy_handler:add(self)
end