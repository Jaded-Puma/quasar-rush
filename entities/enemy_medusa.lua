EnemyMedusa = lazy.extend("EnemyMedusa", EnemyBase)

local SPAWN_DIR_TRACKER = true
local PART_DIST_X = 16 - 8

function EnemyMedusa:constructor(game_logic, config)
    EnemyMedusa.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16, 16
    )

    self.logic = EnemyMedusaLogic(self)
    self.renderer = EnemyMedusaRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(5, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyMedusa:update(dt)
    self.logic:update(dt)
end

function EnemyMedusa:render()
    self.renderer:render()
end

function EnemyMedusa:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    --self.logic.spawn_dir = lazy.math.sign((math.random() * 2) - 1)
    if SPAWN_DIR_TRACKER then
        self.logic.spawn_dir = 1
    else
        self.logic.spawn_dir = -1
    end
    SPAWN_DIR_TRACKER = not SPAWN_DIR_TRACKER

    if self.logic.mode == 12 then
        self.logic.spawn_dir = 1
        self.logic.even = true
    end

    if self.logic.spawn_dir > 0 then
        self.x = -16
        self.y = 0
    else
        self.x = CONFIG.GAME.VIEWPORT.W
        self.y = 0
    end

    if self.logic.mode == 10 then
        self.y = -16
    end

    local hitbox = CONFIG.ENEMY.MEDUSA.HITBOX
    self:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    enemy_handler:add(self)

    if self.logic.mode == 9 or self.logic.mode == 11 or self.logic.mode == 12 then
        self:_create_spawn(self.logic.mode, self, 0 , 0)
    end

    if self.logic.parts > 0 then
        self.spawn_group = {}
        table.insert(self.spawn_group, self)
    end

    
    for i = 1, self.logic.parts do
        local x = 0
        if self.logic.spawn_dir > 0 then
            x = i * -PART_DIST_X
        else
            x = i * PART_DIST_X
        end

        local part = EnemyMedusa(self.game_logic, self.config)
        if self.logic.mode == 10 then
            part.x = self.x
            part.y = self.y - (i * PART_DIST_X)
        else
            part.x = self.x + x
            part.y = self.y
        end
        
        part.logic.spawn_dir = self.logic.spawn_dir
        part.logic.start_angle = self.logic.start_angle
        part.logic.mode = self.logic.mode
        if self.logic.mode == 7 then
            part.logic.base_i = i
            part.logic.wait = 19 * i
        end
        part:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
        enemy_handler:add(part)

        -- TODO  add to function _create_spawn
        if self.logic.mode == 9 or self.logic.mode == 11 then
            part.logic.even = true

            local odd_part = EnemyMedusa(self.game_logic, self.config)
            odd_part.logic.even = false
            odd_part.x = self.x + x
            odd_part.y = self.y
            odd_part.logic.spawn_dir = self.logic.spawn_dir
            odd_part.logic.start_angle = self.logic.start_angle
            odd_part.logic.mode = self.logic.mode
            odd_part:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
            enemy_handler:add(odd_part)
            table.insert(self.spawn_group, odd_part)

        elseif self.logic.mode == 12 then
            part.logic.even = true

            local odd_part = EnemyMedusa(self.game_logic, self.config)
            odd_part.logic.even = false
            odd_part.x = CONFIG.GAME.VIEWPORT.W + (i * PART_DIST_X)
            odd_part.y = self.y
            odd_part.logic.spawn_dir = -1
            odd_part.logic.start_angle = self.logic.start_angle
            odd_part.logic.mode = self.logic.mode
            odd_part:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
            enemy_handler:add(odd_part)
            table.insert(self.spawn_group, odd_part)
        end

        table.insert(self.spawn_group, part)
    end
end

function EnemyMedusa:_create_spawn(mode, from, x, y)
    local hitbox = CONFIG.ENEMY.MEDUSA.HITBOX

    local i = 0

    -- FIXME: put spawn logic inside function
    if mode == 9 or mode == 11 then
        from.logic.even = true

        local odd_part = EnemyMedusa(self.game_logic, self.config)
        odd_part.logic.even = false
        odd_part.x = from.x + x
        odd_part.y = from.y
        odd_part.logic.spawn_dir = from.logic.spawn_dir
        odd_part.logic.start_angle = from.logic.start_angle
        odd_part.logic.mode = from.logic.mode
        odd_part:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
        self.game_logic.enemy_handler:add(odd_part)
        table.insert(self.spawn_group, odd_part)

    elseif mode == 12 then
        from.logic.even = true

        local odd_part = EnemyMedusa(self.game_logic, self.config)
        odd_part.logic.even = false
        odd_part.x = CONFIG.GAME.VIEWPORT.W + (i * PART_DIST_X)
        odd_part.y = from.y
        odd_part.logic.spawn_dir = -1
        odd_part.logic.start_angle = from.logic.start_angle
        odd_part.logic.mode = from.logic.mode
        odd_part:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
        self.game_logic.enemy_handler:add(odd_part)
        table.insert(self.spawn_group, odd_part)
    end
end