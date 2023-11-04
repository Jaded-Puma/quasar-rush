-- Class to spawn enemies at the start of a wave

WaveEnemyEntryOnStart = lazy.extend("WaveEnemyEntryOnStart", WaveEnemyEntryBase)

function WaveEnemyEntryOnStart:constructor(Klass, spawn_number, spawn_data)
    WaveEnemyEntryOnStart.super:initialize(self, Klass, spawn_number, spawn_data)

    self.isStart = false
end

function WaveEnemyEntryOnStart:initiate(game_logic)
    self.isStart = true
end

function WaveEnemyEntryOnStart:exec(game_logic)
    if self.isStart then
        self:spawn(game_logic)
        self.isStart = false
    end
end
