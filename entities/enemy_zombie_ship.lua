EnemyZombieShip = lazy.extend("EnemyZombieShip", EnemyBase)

function EnemyZombieShip:constructor(game_logic, config)
    local size = config[5]
    EnemyZombieShip.super:initialize(
        self,
        game_logic,
        config,
        0, 0,
        16 * size, 16 * size
    )

    self.logic = EnemyZombieShipLogic(self)
    self.renderer = EnemyZombieShipRenderer(self)

    self.render_prio = UTILITY.set_draw_priority(1, self.logic.use_alt_pal, self.logic.pal_mode)
end

function EnemyZombieShip:update(dt)
    self.logic:update(dt)
end

function EnemyZombieShip:render()
    self.renderer:render()
end

function EnemyZombieShip:spawn()
    local enemy_handler = self.game_logic.enemy_handler

    if self.logic.spawn_mode == 1 then
        for i = 1, 6 do
            local x = math.random(1, CONFIG.GAME.VIEWPORT.W - (16 * self.logic.size) - 1)
            local y = -(16 * self.logic.size)
            local w = 16 * self.logic.size
            local h = 16 * self.logic.size

            local isNotColliding = true
            enemy_handler:loop(
                function(e)
                    if not e:typeof(EnemyZombieShip) then return end

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
    elseif self.logic.spawn_mode == 2 or self.logic.spawn_mode == 3 then
        local w = 16 * self.logic.size + 2
        local h = 16 * self.logic.size
        local count = math.floor(CONFIG.GAME.VIEWPORT.W / w)  + 2

        local total_w = w * count
        local offset_x = CONFIG.GAME.VIEWPORT.W / 2 - total_w / 2

        self.spawn_group = {}

        local hole = -1
        if self.logic.spawn_mode == 3  then
            hole = math.random(1, count - 2)
        end

        for i = 0, count - 1 do
            local x = i * w + offset_x
            local y = -h

            if hole ~= i then
                if i == 0 then
                    self:_create_spawn(self, x, y)
                    table.insert(self.spawn_group, self)
                else
                    local enemy = EnemyZombieShip(self.game_logic, self.config)
                    self:_create_spawn(enemy, x, y)
                    table.insert(self.spawn_group, enemy)
                end
            end
        end
    end
end

function EnemyZombieShip:_create_spawn(entity, x, y)
    entity.x = x
    entity.y = y

    local hitbox = CONFIG.ENEMY.ZOMBIE_SHIP.HITBOX
    local _hitbox_w = 16 * entity.logic.size - entity.logic.size * 2
    local _hitbox_h = 16 * entity.logic.size - entity.logic.size * 2
    entity:addBoundingBox(CONFIG.GLOBAL.KEY_HITBOX, hitbox.X, hitbox.Y, _hitbox_w, _hitbox_h)

    entity.game_logic.enemy_handler:add(entity)
end