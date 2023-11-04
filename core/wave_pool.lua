-- Deprecated

WavePool = lazy.class("WavePool")

function WavePool:constructor(entries, set_boss_mode, set_quasar_mode)
    assert(type(entries) == "table", "WavePool.pool is not a table")

    self.pool = {}
    for _, entry in ipairs(entries) do
        table.insert(self.pool, Wave(entry))
    end

    self.current_wave = nil

    self.set_quasar_mode = set_quasar_mode or false
    self.set_boss_mode = set_boss_mode or false
end

function WavePool:initiate(game_logic)
    local rand_i = math.random(#self.pool)
    self.current_wave = self.pool[rand_i]

    self.current_wave:initiate(game_logic)
end

function WavePool:exec(game_logic)
    self.current_wave:exec(game_logic)
end