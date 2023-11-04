-- Class to spawn enemies based on the percent of wave completed.

WaveEnemyEntryOnTrigger = lazy.extend("WaveEnemyEntryOnTrigger", WaveEnemyEntryBase)

function WaveEnemyEntryOnTrigger:constructor(Klass, spawn_number, spawn_data, triggers)
    WaveEnemyEntryOnTrigger.super:initialize(self, Klass, spawn_number, spawn_data)

    self.triggers = triggers
    self.on_start = false
    self.time_triggers = {}

    assert(triggers, "triggers is nil")
    assert(type(triggers) == "table", "triggers must be a table")
end

function WaveEnemyEntryOnTrigger:initiate(game_logic)
    self.time = 0
    -- self.on_start = true
    self.time_triggers = {}

    local time_max = game_logic.wave_time_max

    for i, percent in ipairs(self.triggers) do
        self.time_triggers[i] = lazy.math.round(percent * time_max)
    end
end

function WaveEnemyEntryOnTrigger:exec(game_logic)
    for _, times in ipairs(self.time_triggers) do
        if times == self.time then
            self:spawn(game_logic)
        end
    end

    self.time = self.time + 1
end
