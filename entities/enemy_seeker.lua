EnemySeeker = lazy.extend("EnemySeeker", EnemyBase)

function EnemySeeker:constructor(game_logic, config)
    EnemySeeker.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        24, 8
    )

    self.logic = EnemySeekerLogic(self)
    self.renderer = EnemySeekerRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(7, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemySeeker:update(dt)
    self.logic:update(dt)
end

function EnemySeeker:render()
    self.renderer:render()
end

function EnemySeeker:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    -- spawn modes
    -- 1 normal random 
    -- 2 follow grid / orgnized
    -- 3 center

    if self.logic.spawn_mode == 3 then
        local x = CONFIG.GAME.VIEWPORT.W / 2 - 12
        local y = 24

        self:_create_spawn(self, x, y)
    else 
        for i = 1, 6 do
            local x = math.random(8, 8 + CONFIG.GAME.VIEWPORT.W - 16 - 24)
            local y = math.random(2, 8 * 2 + 4)
            local w = 24
            local h = 8
            if self.logic.spawn_mode == 2 then
                local grid_w = math.floor((CONFIG.GAME.VIEWPORT.W - 8 - 24) / 24)
                local grid_h = 2 
                x = 8 + math.random(0, grid_w - 1) * 24
                y = 2 + math.random(0, grid_h - 1) * 8
            end

            local isNotColliding = true
            enemy_handler:loop(
                function(e)
                    if not e:typeof(EnemySeeker) then return end
    
                    if lazy.util.is_box_inside_box(x, y, w, h, e.x, e.y, e.w, e.h) then
                        isNotColliding = false
                    end
                end
            )
    
            if isNotColliding then
                self:_create_spawn(self, x, y)
                break
            end
        end 
    end
end

function EnemySeeker:_create_spawn(entity, x, y)
    entity.x = x
    entity.y = y
    local hitbox = CONFIG.ENEMY.SEEKER.HITBOX
    entity:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, hitbox.W, hitbox.H)
    self.game_logic.enemy_handler:add(entity)
end