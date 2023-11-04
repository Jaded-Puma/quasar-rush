EnemyPeek = lazy.extend("EnemyPeek", EnemyBase)

local SPAWN_DIR_TRACKER = true
local PEEK_Y_VARIATION = 12

function EnemyPeek:constructor(game_logic, config)
    EnemyPeek.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16, 16
    )

    self.logic = EnemyPeekLogic(self)
    self.renderer = EnemyPeekRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(3, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyPeek:update(dt)
    self.logic:update(dt)
end

function EnemyPeek:render()
    self.renderer:render()
end

function EnemyPeek:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    local w = 16
    local h = 16

    if self.logic.spawn_mode == 1 then
        for i = 1, 6 do
            local x = 0
            local vw = (CONFIG.GAME.VIEWPORT.W - 16)
            if SPAWN_DIR_TRACKER then
                x = math.random(1, vw / 2)
            else
                x = math.random(vw / 2, vw)
            end
            SPAWN_DIR_TRACKER = not SPAWN_DIR_TRACKER

            -- local x = math.random() * (CONFIG.GAME.VIEWPORT.W - 16)
            local y = CONFIG.GAME.VIEWPORT.H

            local isNotColliding = true
            enemy_handler:loop(
                function(e)
                    if not e:typeof(EnemyPeek) then return end

                    if lazy.util.is_box_inside_box(x, 0, w, h, e.x, 0, e.w, e.h) then
                        isNotColliding = false
                    end
                end
            )

            if isNotColliding then
                self:_create_spawn(self, x, y)
                break
            end
        end
    elseif self.logic.spawn_mode == 2 then
        local x = CONFIG.GAME.VIEWPORT.W / 2 - 8
        local y = CONFIG.GAME.VIEWPORT.H

        if not self:_is_wall_wall_collision(x, w, h) then
            self:_create_spawn(self, x, y)
        end
    elseif self.logic.spawn_mode == 3 then
        local x_offset = CONFIG.GAME.VIEWPORT.W / 3

        local x = x_offset - 8
        local y = CONFIG.GAME.VIEWPORT.H
        self:_create_spawn(self, x, y)

        local peek = EnemyPeek(self.game_logic, self.config)
        x = x_offset * 2 - 8
        y = CONFIG.GAME.VIEWPORT.H
        self:_create_spawn(peek, x, y)
    end
end

--- TODO can be generalized into a n UTIL class
function EnemyPeek:_is_wall_wall_collision(x, w, h)
    local isColliding = false
    self.game_logic.enemy_handler:loop(
        function(e)
            if not e:typeof(EnemyPeek) then return end

            if lazy.util.is_box_inside_box(x, 0, w, h, e.x, 0, e.w, e.h) then
                isColliding = true
            end
        end
    )

    return isColliding
end

function EnemyPeek:_create_spawn(entity, x, y)
    entity.x = x
    entity.y = y
    entity.logic.base_y = entity.y
    local hitbox = CONFIG.ENEMY.PEEK.HITBOX
    local h_offset = entity.logic.peek_amount - hitbox.H
    entity:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H + h_offset)
    entity.game_logic.enemy_handler:add(entity)
end