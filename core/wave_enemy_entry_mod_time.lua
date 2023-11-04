WaveEnemyEntryModTime = lazy.extend("WaveEnemyEntryModTime", WaveEnemyEntryBase)

function WaveEnemyEntryModTime:constructor(Klass, spawn_number, spawn_data, spawn_time_max)
    WaveEnemyEntryModTime.super:initialize(self, Klass, spawn_number, spawn_data)

    self.spawn_time_max = spawn_time_max
    self.spawn_time  = 0

    assert(self.spawn_time_max  > 0, "self.spawn_time_max  must be positive integer")
end

function WaveEnemyEntryModTime:initiate(game_logic)
    self.spawn_time = self.spawn_time_max
end

function WaveEnemyEntryModTime:exec(game_logic)
    if self.spawn_time == 0 then
        self:initiate()
        self:spawn(game_logic)
    else
        self.spawn_time = self.spawn_time - 1
    end
end