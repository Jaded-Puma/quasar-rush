ControlledRandom = lazy.class("ControlledRandom")

local ID = 1
local COUNT = 2
local OFFSET = 3

function ControlledRandom:constructor(id_table)
    self.id_table = id_table
    self.track_table = {}

    for i, entry in ipairs(id_table) do
        self:_update_tracker(i)
    end
end

function ControlledRandom:next()
    for i = #self.track_table, 1, -1 do
        -- return default
        if i == 1 then
            return self.id_table[i][ID]
        end

        -- return weighted
        if self.track_table[i] < 1 then
            self:_update_tracker(i)
            return self.id_table[i][ID]
        else
            self.track_table[i] = self.track_table[i] - 1
        end
    end
end

function ControlledRandom:_update_tracker(id)
    self.track_table[id] = self.id_table[id][COUNT] + math.random(-self.id_table[id][OFFSET], self.id_table[id][OFFSET])
end