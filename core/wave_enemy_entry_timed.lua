WaveEnemyEntryTimed = lazy.extend("WaveEnemyEntryTimed", WaveEnemyEntryBase)

local GLOBAL_START_TIMEOUT = 30

function WaveEnemyEntryTimed:constructor(Klass, spawn_number, spawn_data, spawn_time_mod)
    WaveEnemyEntryTimed.super:initialize(self, Klass, spawn_number, spawn_data)

    self.spawn_time_mod = spawn_time_mod

    self.timeout = GLOBAL_START_TIMEOUT

    assert(self.spawn_time_mod  > 0, "self.spawn_time_max  must be positive integer")
end

function WaveEnemyEntryTimed:initiate(game_logic)

end

function WaveEnemyEntryTimed:exec(game_logic)
    if self.timeout ~= 0 then
        self.timeout = self.timeout - 1
        return
    end

    if FRAME % self.spawn_time_mod == 0 then
        self:initiate()
        self:spawn(game_logic)
    end
end