-- Enemy data file which determines the attributes that can be modified in any one enemy object

local NONE = "NONE"

local modify = function(config, ...)
    local tbl = {...}
    assert(#tbl == #config, "Array mismatched.")

    for i, value in ipairs(tbl) do
        if value == NONE then
            tbl[i] = config[i]
        end
    end

    return tbl
end

-- local speed = UTILITY.get_num_spread(0.24, 1.32, 6)
local speed = UTILITY.get_num_spread(0.24, 1.14, 6)

local CONFIG_ZOMBIE = {
    -- hp/speed/pal/pal_mode/size/spawn_mode
    ["GREEN_BASE"]  = {10, speed[1], false, 1, 1, 1}, 
    ["BLUE_BASE"]   = {20, speed[2], false, 2, 1, 1},
    ["YELLOW_BASE"] = {20, speed[3], false, 3, 1, 1},
    ["RED_BASE"]    = {30, speed[4], false, 4, 1, 1},
    ["PURPLE_BASE"] = {30, speed[5], false, 5, 1, 1},
    ["WHITE_BASE"]  = {40, speed[6], false, 6, 1, 1},
    ["FUSION_BASE"] = {50, speed[7], false, 7, 1, 1},

    ["DEBUG_CORRUPT"] = {-1, 1.32, true, 2, 1, 3},

    ["BOSS"] = {150, 0.12, true, 2, 2, 2},

    ["IMMUNE"] = {-1, 0.12, false, 5, 1, 1},
}
CONFIG_ZOMBIE["GREEN_BASE_IMMUNE"] = modify(CONFIG_ZOMBIE["GREEN_BASE"], -1, NONE, NONE, NONE, NONE, NONE)
CONFIG_ZOMBIE["BLUE_BASE_SLOW"] = modify(CONFIG_ZOMBIE["BLUE_BASE"], NONE, 0.20, NONE, NONE, NONE, NONE)
CONFIG_ZOMBIE["FUSION_BASE_S3_SLOW"] = modify(CONFIG_ZOMBIE["FUSION_BASE"], NONE, 0.46, NONE, NONE, NONE, 3)
CONFIG_ZOMBIE["RED_BASE_M2"] = modify(CONFIG_ZOMBIE["RED_BASE"], NONE, NONE, NONE, NONE, NONE, 2)
CONFIG_ZOMBIE["FUSION_BASE_WALL"] = modify(CONFIG_ZOMBIE["FUSION_BASE"], NONE, NONE, NONE, NONE, NONE, 2)

CONFIG_ZOMBIE["WHITE_BASE_SLOW"] = modify(CONFIG_ZOMBIE["WHITE_BASE"], NONE, 0.5, NONE, NONE, 2, NONE)

CONFIG_ZOMBIE["BOSS_1"] = modify(CONFIG_ZOMBIE["BOSS"], 60, NONE, NONE, NONE, 1, NONE)
CONFIG_ZOMBIE["BOSS_2"] = modify(CONFIG_ZOMBIE["BOSS"], NONE, NONE, NONE, NONE, NONE, NONE)

CONFIG_ZOMBIE["QUASAR_WALL"] = modify(CONFIG_ZOMBIE["PURPLE_BASE"], -1, 0.80, true, NONE, NONE, 3)
CONFIG_ZOMBIE["QUASAR_BIG"] = modify(CONFIG_ZOMBIE["PURPLE_BASE"], -1, 0.80, true, NONE, 2, 3)

CONFIG_ZOMBIE["QUASAR_SUPPORT"] = modify(CONFIG_ZOMBIE["PURPLE_BASE"], 120, 0.24, true, NONE, 2, NONE)

CONFIG_ZOMBIE["BLUE_BASE_SPECIAL"]   = modify(CONFIG_ZOMBIE["BLUE_BASE"], 60, NONE, NONE, NONE, 2, NONE)
CONFIG_ZOMBIE["YELLOW_BASE_SPECIAL"] = modify(CONFIG_ZOMBIE["YELLOW_BASE"], 60, NONE, NONE, NONE, 2, NONE)
CONFIG_ZOMBIE["RED_BASE_SPECIAL"]    = modify(CONFIG_ZOMBIE["RED_BASE"], 60, NONE, NONE, NONE, 2, NONE)



local speed = UTILITY.get_num_spread(0.50, 1.15, 6)

local CONFIG_SHOOTER = {
    -- hp/speed/pal/pal_mode/atk_mode/attack_timeout/proj_speed/shoots
    ["GREEN_BASE"]  = {10, speed[1], false, 1, 1, 90, 1.9, 1},
    ["BLUE_BASE"]   = {20, speed[2], false, 2, 1, 85, 1.9, 3},
    ["YELLOW_BASE"] = {20, speed[3], false, 3, 2, 80, 1.9, 1},
    ["RED_BASE"]    = {30, speed[4], false, 4, 2, 60, 2.4, 2},
    ["PURPLE_BASE"] = {40, speed[5], false, 5, 2, 50, 2.4, 3},
    ["WHITE_BASE"]  = {50, speed[6], false, 6, 1, 40, 2.8, 8},
    ["FUSION_BASE"] = {60, speed[7], false, 7, 2, 30, 2.8, 5},

    ["DEBUG_CORRUPT"] = {9999, 1.33, true, 2, 1, 90, 1.2, 2},

    ["BOSS"] = {-1, 6.89, true, 2, 2, 15, 2.4, 15}, -- 0.89

    ["IMMUNE"] = {-1, 1.0, false, 5, 2, 90, 0.8, 3},
}
CONFIG_SHOOTER["QUASAR_WALL"] = modify(CONFIG_SHOOTER["FUSION_BASE"], -1, NONE, true, NONE, 1, 10, 4.5, 4)
CONFIG_SHOOTER["QUASAR_1"] = modify(CONFIG_SHOOTER["FUSION_BASE"], NONE, NONE, true, NONE, 1, 60, 0.4, 9999)
CONFIG_SHOOTER["QUASAR_2"] = modify(CONFIG_SHOOTER["FUSION_BASE"], NONE, NONE, true, 6, 2, 30, 0.6, 1)
CONFIG_SHOOTER["QUASAR_SUPPORT"] = modify(CONFIG_SHOOTER["FUSION_BASE"], -1, 32, true, 6, 1, 2, 1.6, 1)

local CONFIG_PEEK = {
    -- hp/peek_rate/pal/pal_mode/peek_amound/spawn_mode
    ["GREEN_BASE"]  = {60,  71, false, 1, 8*0+4, 1},
    ["BLUE_BASE"]   = {70,  66, false, 2, 8*1, 1},
    ["YELLOW_BASE"] = {80,  52, false, 3, 8*2, 1},
    ["RED_BASE"]    = {90,  45, false, 4, 8*3, 1},
    ["PURPLE_BASE"] = {100, 40, false, 5, 8*4, 1},
    ["WHITE_BASE"]  = {120, 37, false, 6, 8*4, 1},
    ["FUSION_BASE"] = {180, 32, false, 7, 8*5, 1},

    ["DEBUG_CORRUPT"] = {9999, 100, true, 2, 8*5, 1},

    ["BOSS"] = {300, 467, true, 2, 256, 3},

    ["IMMUNE"] = {-1, 1.0, false, 2, 0, 1},
}
CONFIG_PEEK["GREEN_BASE_MID"]  = modify(CONFIG_PEEK["GREEN_BASE"], NONE, NONE, NONE, NONE, NONE, 2)
CONFIG_PEEK["BLUE_IMMUNE_MID"] = modify(CONFIG_PEEK["GREEN_BASE"], -1, NONE, NONE, NONE, NONE, 2)

CONFIG_PEEK["FUSION_BASE_S3"]  = modify(CONFIG_PEEK["FUSION_BASE"], NONE, NONE, NONE, NONE, NONE, 3)

CONFIG_PEEK["QUASAR"] = modify(CONFIG_PEEK["FUSION_BASE"], 170, NONE, true, NONE, 8*10, NONE)


local CONFIG_MEDUSA = {
    -- hp/speed/pal/pal_mode/atk_mode/parts
    -- atk_mode:
    -- 1 sin
    -- 2 square
    -- 3 versin
    -- 4 1 - versin

    -- 5 sin + square
    -- 6 versin both
    -- 7 follow circ

    -- 8 wall
    -- 9 2xsin
    -- 10 top down sin
    -- 11 helix
    -- 12 opposite sin
    ["GREEN_BASE"]  = {10, 0.62, false, 1, 1, 0},
    ["BLUE_BASE"]   = {10, 0.70, false, 2, 1, 2},
    ["YELLOW_BASE"] = {20, 0.80, false, 3, 2, 3},
    ["RED_BASE"]    = {20, 0.90, false, 4, 3, 4},
    ["PURPLE_BASE"] = {30, 0.99, false, 5, 3, 5},
    ["WHITE_BASE"]  = {30, 1.00, false, 6, 4, 7},
    ["FUSION_BASE"] = {20, 0.80, false, 7, 11, 8},

    ["DEBUG_CORRUPT"] = {9999, 0.50, true, 6, 7, 83},  -- speed 0.8

    ["BOSS"] = {20, 0.02, true, 2, 8, 13},

    ["IMMUNE"] = {-1, 0.69, false, 5, 2, 5},
}
-- custom
CONFIG_MEDUSA["GREEN_BASE_P2"] = modify(CONFIG_MEDUSA["GREEN_BASE"], NONE, NONE, NONE, NONE, NONE, 2)
CONFIG_MEDUSA["BLUE_BASE_P5"] = modify(CONFIG_MEDUSA["BLUE_BASE"], NONE, NONE, NONE, NONE, NONE, 5)
CONFIG_MEDUSA["BLUE_BASE_M2_P5"] = modify(CONFIG_MEDUSA["BLUE_BASE"], NONE, NONE, NONE, NONE, 2, 4)

CONFIG_MEDUSA["BLUE_BASE_M1_P8"] = modify(CONFIG_MEDUSA["BLUE_BASE"], NONE, NONE, NONE, NONE, 1, 8)
CONFIG_MEDUSA["BLUE_BASE_M12_P8"] = modify(CONFIG_MEDUSA["BLUE_BASE"], NONE, NONE, NONE, NONE, 12, 8)

CONFIG_MEDUSA["BLUE_BASE_M9_P8"] = modify(CONFIG_MEDUSA["BLUE_BASE"], NONE, NONE, NONE, NONE, 9, 8)

CONFIG_MEDUSA["YELLOW_BASE_M6_P6"] = modify(CONFIG_MEDUSA["YELLOW_BASE"], NONE, 0.42, NONE, NONE, 6, 6)

CONFIG_MEDUSA["YELLOW_BASE_M3_P6"] = modify(CONFIG_MEDUSA["YELLOW_BASE"], NONE, 0.42, NONE, NONE, 3, 6)
CONFIG_MEDUSA["YELLOW_BASE_M4_P6"] = modify(CONFIG_MEDUSA["YELLOW_BASE"], NONE, 0.42, NONE, NONE, 4, 6)
CONFIG_MEDUSA["YELLOW_BASE_M10_P3"] = modify(CONFIG_MEDUSA["YELLOW_BASE"], NONE, 0.12, NONE, NONE, 10, 3)

CONFIG_MEDUSA["PURPLE_BASE_BOSS"] = modify(CONFIG_MEDUSA["PURPLE_BASE"], NONE, 0.70, NONE, NONE, 1, 6)

CONFIG_MEDUSA["YELLOW_BASE_M2_P5"] = modify(CONFIG_MEDUSA["YELLOW_BASE"], NONE, NONE, NONE, NONE, 2, 5)
CONFIG_MEDUSA["WHITE_BASE_M2_P16"] = modify(CONFIG_MEDUSA["WHITE_BASE"], NONE, NONE, NONE, NONE, 1, 16)

CONFIG_MEDUSA["WHITE_BASE_BLOCK"] = modify(CONFIG_MEDUSA["WHITE_BASE"], NONE, NONE, NONE, NONE, 9, 14)

CONFIG_MEDUSA["FUSION_BASE_CIRC"] = modify(CONFIG_MEDUSA["FUSION_BASE"], 190, 0.62, NONE, NONE, 7, 90)

CONFIG_MEDUSA["QUASAR_1"] = modify(CONFIG_MEDUSA["FUSION_BASE"], 30, 0, true, NONE, 9, 215)
CONFIG_MEDUSA["QUASAR_2"] = modify(CONFIG_MEDUSA["FUSION_BASE"], NONE, 0.10, true, 6, 10, 0)


local CONFIG_KAMIKAZE = {
    -- hp/speed/pal/pal_mode/aim_timout/attack_timeout
    ["GREEN_BASE"]  = {10, 1.4, false, 1, 120, 100},
    ["BLUE_BASE"]   = {20, 1.4, false, 2, 120, 80},
    ["YELLOW_BASE"] = {20, 1.4, false, 3, 100, 70},
    ["RED_BASE"]    = {30, 1.5, false, 4, 90,  70},
    ["PURPLE_BASE"] = {30, 1.6, false, 5, 80,  60},
    ["WHITE_BASE"]  = {30, 1.7, false, 6, 70,  50},
    ["FUSION_BASE"] = {40, 1.8, false, 7, 50,  50},

    ["DEBUG_CORRUPT"] = {9999, 1.0, true, 2, 100, 100},

    ["BOSS"] = {10, 1.8, true, 2, 30, 65},

    ["IMMUNE"] = {-1, 1.0, false, 5, 100, 100},
}
CONFIG_KAMIKAZE["QUASAR_SUPPORT"] = modify(CONFIG_KAMIKAZE["FUSION_BASE"], NONE, 1.2, true, NONE, NONE, 90)
CONFIG_KAMIKAZE["QUASAR"] = modify(CONFIG_KAMIKAZE["FUSION_BASE"], 30, NONE, true, NONE, 5, 80)


local speed = UTILITY.get_num_spread(0.7, 1.8, 6)

local CONFIG_BOUNCE = {
    -- hp/speed/pal/pal_mode/bounces
    ["GREEN_BASE"]  = {30, speed[1], false, 1, -1},
    ["BLUE_BASE"]   = {30, speed[2], false, 2, -1},
    ["YELLOW_BASE"] = {40, speed[3], false, 3, -1},
    ["RED_BASE"]    = {50, speed[4], false, 4, -1},
    ["PURPLE_BASE"] = {70, speed[5], false, 5, -1},
    ["WHITE_BASE"]  = {80, speed[6], false, 6, -1},
    ["FUSION_BASE"] = {90, speed[7], false, 7, -1},

    ["DEBUG_CORRUPT"] = {9999, 1.0, true, 2, -1},

    ["BOSS"] = {120, 1.45, true, 2, -1},

    ["IMMUNE"] = {-1, 1.0, false, 1, -1},
}
CONFIG_BOUNCE["GREEN_IMMUNE"] = modify(CONFIG_BOUNCE["GREEN_BASE"], -1, NONE, NONE, NONE, NONE)

CONFIG_BOUNCE["QUASAR_1"] = modify(CONFIG_BOUNCE["FUSION_BASE"], 80, 1.5, true, 7, NONE)
CONFIG_BOUNCE["QUASAR_2"] = modify(CONFIG_BOUNCE["FUSION_BASE"], 10000, 2.5, true, 7, NONE)


local CONFIG_ORGANIC = {
    -- hp/speed/pal/pal_mode/atk_mode/attack_timeout/proj_speed
    ["GREEN_BASE"]  = {80,  0.4, false, 1, 1, 120, 1.2},
    ["BLUE_BASE"]   = {90,  0.4, false, 2, 1, 110, 1.2},
    ["YELLOW_BASE"] = {110, 0.4, false, 3, 1, 90,  1.2},
    ["RED_BASE"]    = {140, 0.4, false, 4, 1, 80,  1.2},
    ["PURPLE_BASE"] = {160, 0.4, false, 5, 1, 80,  1.2},
    ["WHITE_BASE"]  = {160, 0.4, false, 6, 1, 70,  1.2},
    ["FUSION_BASE"] = {180, 0.4, false, 7, 1, 60,  2.2},

    ["DEBUG_CORRUPT"] = {9999, 1.5, true, 2, 1, 10000, 1.2},

    ["BOSS"] = {250, 1.3, true, 2, 3, 75, 0.85},

    ["IMMUNE"] = {-1, 0.4, false, 5, 1, 90, 1.2},
}
CONFIG_ORGANIC["GREEN_BASE_WEAK_IMMUNE"] = modify(CONFIG_ORGANIC["GREEN_BASE"], -1, NONE, NONE, NONE, NONE, 160, 0.8)
CONFIG_ORGANIC["FUSION_BASE_M2"] = modify(CONFIG_ORGANIC["FUSION_BASE"], NONE, NONE, NONE, NONE, 2, NONE, NONE)
CONFIG_ORGANIC["QUASAR"] = modify(CONFIG_ORGANIC["FUSION_BASE"], 440, 17, true, NONE, 1, 3, 0.31)

local CONFIG_SEEKER = {
    -- hp / pal / pal_mode / mode / proj_speed / proj_acc / atk_frame / accuracy / spawn_mode
    ["GREEN_BASE"]  = {40, false, 1, 2, 0.70, 0.0, 190, 0.025, 2},
    ["BLUE_BASE"]   = {40, false, 2, 2, 0.65, 0.0, 170, 0.019, 2},
    ["YELLOW_BASE"] = {50, false, 3, 2, 0.60, 0.0, 150, 0.022, 2},
    ["RED_BASE"]    = {60, false, 4, 2, 0.50, 0.0, 150, 0.028, 2},
    ["PURPLE_BASE"] = {70, false, 5, 2, 0.35, 0.0, 150, 0.028, 2},
    ["WHITE_BASE"]  = {80, false, 6, 2, 3.70, 0.0, 100, 0.0, 2},
    ["FUSION_BASE"] = {80, false, 7, 2, 2.70, 0.0, 150, 0.29, 2},

    ["DEBUG_CORRUPT"] = {9999, true, 3, 3, 0.3, 0.0085, 15, 0.00023, 3},

    ["BOSS"] = {480, true, 2, 2, 0.0, 0.045, 65, 0.19, 3},

    ["IMMUNE"] = {30, false, 1, 1, 0.7, 0.0, 170, 0.0002, 2},
}
CONFIG_SEEKER["GREEN_BASE_MID"] = modify(CONFIG_SEEKER["GREEN_BASE"], NONE, NONE, NONE, NONE, NONE, NONE, NONE, NONE, 3)

CONFIG_SEEKER["GREEN_BASE_IMMUNE"] = modify(CONFIG_SEEKER["GREEN_BASE"], -1, NONE, NONE, NONE, 0.75, NONE, 91, 0.0, 3)
CONFIG_SEEKER["GREEN_BASE_IMMUNE_ALT"] = modify(CONFIG_SEEKER["GREEN_BASE"], -1, NONE, NONE, NONE, 0.75, NONE, 91, 0.0, 2)


CONFIG_SEEKER["QUASAR"] = {9999, true, 3, 3, 1.2, 0.0135, 10, 0.037, 3} -- idea for quasar mode


WAVE_KEY = {
    "GREEN_BASE",
    "BLUE_BASE",
    "YELLOW_BASE",
    "RED_BASE",
    "PURPLE_BASE",
    "WHITE_BASE",
    "FUSION_BASE",
    "DEBUG_CORRUPT",
    "BOSS",
    "IMMUNE"
}

WAVE_CONFIG = {
    ZOMBIE = CONFIG_ZOMBIE,
    SHOOTER = CONFIG_SHOOTER,
    PEEK = CONFIG_PEEK,
    MEDUSA = CONFIG_MEDUSA,
    KAMIKAZE = CONFIG_KAMIKAZE,
    BOUNCE = CONFIG_BOUNCE,
    ORGANIC = CONFIG_ORGANIC,
    SEEKER = CONFIG_SEEKER
}