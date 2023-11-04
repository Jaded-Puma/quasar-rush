Wave = lazy.class("Wave")

function Wave:constructor(enemy_entries, set_boss_mode, set_quasar_mode)
    self.enemy_entries = enemy_entries

    self.set_quasar_mode = set_quasar_mode or false
    self.set_boss_mode = set_boss_mode or false

    assert(type(enemy_entries) == "table", "enemy_entries not a table")
end

function Wave:initiate(game_logic)
    for _, enemy_entry in ipairs(self.enemy_entries) do
        enemy_entry:initiate(game_logic)
    end
end

function Wave:exec(game_logic)
    for _, enemy_entry in ipairs(self.enemy_entries) do
        enemy_entry:exec(game_logic)
    end
end