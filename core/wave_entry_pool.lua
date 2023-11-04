WaveEntryPool = lazy.class("WaveEntryPool")

function WaveEntryPool:constructor(...)
    self.entries = {...}

    self.current_entry = nil
end

function WaveEntryPool:initiate(game_logic)
    local rand_i = math.random(#self.entries)
    self.current_entry = self.entries[rand_i]

    self.current_entry:initiate(game_logic)
end

function WaveEntryPool:exec(game_logic)
    self.current_entry:exec(game_logic)
end
