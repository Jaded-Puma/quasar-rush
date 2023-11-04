-- Abstract class to control spawning enemies

WaveEnemyEntryBase = lazy.class("WaveEnemyEntryBase")

function WaveEnemyEntryBase:constructor(Klass, spawn_number, spawn_data)
    self.Klass = Klass
    self.spawn_number = spawn_number
    self.spawn_data = spawn_data

    assert(Klass, "Wave Klass is nil")
    assert(self.spawn_number > 0, "spawn_number must me positive interger")
    assert(type(self.spawn_data) == "table", "spawn_data must be table")
end


function WaveEnemyEntryBase:initiate(game_logic)

end


function WaveEnemyEntryBase:exec(game_logic)

end


function WaveEnemyEntryBase:spawn(game_logic)
    local enemies = {}

    for n = 1, self.spawn_number do
        table.insert(enemies, self:single_spawn(game_logic))
    end

    return enemies
end

function WaveEnemyEntryBase:single_spawn(game_logic)
    local enemy = self.Klass(game_logic, self.spawn_data)
    enemy:spawn()

    return enemy
end