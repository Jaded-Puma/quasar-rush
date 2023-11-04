-- spawn enemies with a range of time between them.

WaveEnemyEntryRange = lazy.extend("WaveEnemyEntryRange", WaveEnemyEntryBase)

function WaveEnemyEntryRange:constructor(Klass, spawn_number, spawn_data, spawn_time_min, spawn_time_spread)
    WaveEnemyEntryRange.super:initialize(self, Klass, spawn_number, spawn_data)

    self.spawn_time_min = spawn_time_min
    self.spawn_time_max = spawn_time_min + spawn_time_spread

    assert(self.spawn_time_min > 0, "spawn_time_min must be positive integer")
    assert(self.spawn_time_max > 0, "spawn_time_max must be positive integer")
    
    self.spawn_time  = 0
end

function WaveEnemyEntryRange:initiate(game_logic)
    self.spawn_time  = math.random(self.spawn_time_min, self.spawn_time_max)
end

function WaveEnemyEntryRange:exec(game_logic)
    if self.spawn_time == 0 then
        self:initiate()
        self:spawn(game_logic)
    else
        self.spawn_time = self.spawn_time - 1
    end
end