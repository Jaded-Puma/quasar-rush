-- Class to always spawn enemies defined in the wave_data file.

WaveEnemyEntryAlways = lazy.extend("WaveEnemyEntryAlways", WaveEnemyEntryBase)

local DEFAULT_COOLDOWN = 60

function WaveEnemyEntryAlways:constructor(Klass, spawn_number, spawn_data, delay, cooldown_max)
    WaveEnemyEntryAlways.super:initialize(self, Klass, spawn_number, spawn_data)

    self.delay = delay or 0

    self.cooldown_max = cooldown_max or DEFAULT_COOLDOWN
    self.timeout = {}
    for i = 1, spawn_number do
        self.timeout[i] = 0
    end
    self.buffer = {}

    self.enemies = {}
end

function WaveEnemyEntryAlways:initiate(game_logic)
    self.enemies = {}

    self.timeout = self.delay
end

function WaveEnemyEntryAlways:exec(game_logic)
    if self.timeout > 0 then
        self.timeout = self.timeout - 1
        return
    end

    -- keep trying to spawn
    if next(self.enemies) == nil then
        self.enemies = self:spawn(game_logic)
    end

    -- check buffer
    for i, cooldown in pairs(self.buffer) do
        if cooldown ~= 0 then
            self.buffer[i] = self.buffer[i] - 1
        else
            self.buffer[i] = nil
            self.enemies[i] = self:single_spawn(game_logic)
        end
    end

    -- check spawn
    for i, enemy in ipairs(self.enemies) do
        if self.buffer[i] == nil then
        
        -- enemy group
        if next(enemy.spawn_group) ~= nil then
            -- check deleted
            local all_deleted = true
            for _, enemy_spawn in ipairs(enemy.spawn_group) do
                if not enemy_spawn.delete then
                    all_deleted = false
                end
            end

            -- if group deleted, new spawn
            if all_deleted then
                -- self.enemies[i] = self:single_spawn(game_logic)
                self:_add_buffer(i)
            end
        -- single enemy
        else
            -- check for failed spawns
            local exists = false
            game_logic.enemy_handler:loop(
                function(enemy_in_handler)
                    if enemy == enemy_in_handler then
                        exists = true
                    end
                end
            )
    
            -- remove failed spawns
            if not exists then
                enemy.delete = true
            end
    
            -- new spawn
            if enemy.delete then
                -- self.enemies[i] = self:single_spawn(game_logic)
                self:_add_buffer(i)
            end
        end
        end
    end
end

function WaveEnemyEntryAlways:_add_buffer(i)
    self.buffer[i] = self.cooldown_max
end