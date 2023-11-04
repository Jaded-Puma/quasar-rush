-- Global utility for game logic

UTILITY = {}

UTILITY.conver_direction_spr = function(dir)
    if dir == 1 then
        return 0
    else
        return 1
    end
end

local INIT_PRIO = 1000000
local PRIO_MUL = 1000
local ALT_MUL = 2
local PAL_MODE_MUL = 100
local PAL_MODE_TOTAL = #CONFIG.GLOBAL.PAL_MODE
local PRIO_COUNT = 0

UTILITY.set_draw_priority = function(prio, alt, pal_mode)
    local pal_value = (PAL_MODE_TOTAL - pal_mode) * PAL_MODE_MUL
    local alt_mul = (alt and ALT_MUL or 0)
    local prio_value = INIT_PRIO * alt_mul + prio * PRIO_MUL - pal_value - PRIO_COUNT

    PRIO_COUNT = PRIO_COUNT + 1
    PRIO_COUNT = PRIO_COUNT % PAL_MODE_MUL

    return prio_value
end

UTILITY.get_weighted_value = function(weight_table)
    local total = 0

    for _, weight in ipairs(weight_table) do
        total = total + weight
    end

    local choose = math.random(0, total)

    local previous = 0
    for i, weight in ipairs(weight_table) do
        if choose <= previous + weight then
            return i
        else
            previous = previous + weight
        end
    end
end

--- FIXME: should be part of the renderer class
UTILITY.get_pal = function(entity)
    local pal = CONFIG.GLOBAL.PAL_MODE[entity.logic.pal_mode]
    if entity.logic:is_immune() then
        pal = CONFIG.GLOBAL.IMMUNE_PAL
    end

    return pal
end

--- FIXME: should be part of the renderer class
UTILITY.get_anim = function(entity)
    local anim = entity.renderer.animation
    if entity.logic.use_alt_pal then
        anim = entity.renderer.animation_alt
    end

    return anim
end

UTILITY.get_num_spread = function(start_value, end_value, slices)    
    local slice_tbl = {}

    local slice = (end_value - start_value) / slices

    for i = 0, slices do
        table.insert(slice_tbl, start_value + i * slice)
    end

    return slice_tbl
end