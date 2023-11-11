-- This file will contaion wave data for each wave
-- this is the way to control the increase in challenge for waves
WAVE_DATA = {}

local ZOMBIE = WAVE_CONFIG.ZOMBIE
local SHOOTER = WAVE_CONFIG.SHOOTER
local PEEK = WAVE_CONFIG.PEEK
local MEDUSA = WAVE_CONFIG.MEDUSA
local KAMIKAZE = WAVE_CONFIG.KAMIKAZE
local BOUNCE = WAVE_CONFIG.BOUNCE
local ORGANIC = WAVE_CONFIG.ORGANIC
local SEEKER = WAVE_CONFIG.SEEKER

local trigger = function(num)
    local tbl = {}

    local max_time = 1.0

    local frac_time = max_time / (num + 1)

    for i = 1, num do
        table.insert(tbl, frac_time * i)
    end

    return tbl
end

local trigger_table = function(...)
    return { ... }
end

local TRIGGER = {
    AT_10 = trigger_table(1/10),
    AT_25 = trigger_table(1/4),
    AT_50 = trigger_table(1/2),
    AT_75 = trigger_table(3/4),
    AT_90 = trigger_table(9/10),
    -- WITH_1_AT_1_2_TIME = trigger(1), -- same as AT_50
    WITH_2_AT_1_3_TIME = trigger(2),
    WITH_3_AT_1_4_TIME = trigger(3),
    WITH_4_AT_1_5_TIME = trigger(4),
    WITH_5_AT_1_6_TIME = trigger(5),
}
DEBUG_WAVE_CONFIG = {
    LEVEL = 0,
    WAVE = 1,
    SET = function(wave, level)
        DEBUG_WAVE_CONFIG.WAVE = wave
        DEBUG_WAVE_CONFIG.LEVEL = level
    end,
}

-- debug wave
local DEBUG_WAVE = false
if DEBUG_WAVE then
    table.insert(WAVE_DATA,
        -- Wave(
        --     {
        --         WaveEntryPool(
        --             WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["GREEN_BASE"]),
        --             WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["BOSS"])
        --         )
        --     }
        -- )

        -- WavePool(
        --     {
        --         {
        --             WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["GREEN_BASE"]),
        --             WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["GREEN_BASE"]),
        --         },
        --         {
        --             WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["BOSS"])
        --         }
        --     }
        -- )

        Wave(
            {
                WaveEnemyEntryAlways(EnemySeeker, 1 , SEEKER["GREEN_BASE"], 600)
            }
        )
    )
end

if DEMO_MODE then
    -- DEBUG_WAVE_CONFIG.SET(10, 0)

    DEMO_STRING = "DEMO"
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyZombieShip, 8, ZOMBIE["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyShooter, 3, SHOOTER["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyPeek, 2, PEEK["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyMedusa, 2, MEDUSA["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyKamikaze, 2, KAMIKAZE["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["GREEN_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyOrganic, 1, ORGANIC["GREEN_BASE"]),
            }
        )
    )
    
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["GREEN_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["BLUE_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["YELLOW_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["RED_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["PURPLE_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["WHITE_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["FUSION_BASE"]),
            }
        )
    )

    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyZombieShip, 1, ZOMBIE["BOSS"]),
            }
        )
    )

    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyOrganic, 1, ORGANIC["IMMUNE"]),
            }
        )
    )
else
    --[[
    w3 = lvl8-10

    w6 = lvl18

    w9 = lvl22-24

    w12 = lvl30

    w15 = 34-35

    w18 = 34?
    ]]--
    local level_per_wave = 2.85

    local wave = DEBUG_START_WAVE
    local level = math.floor(wave * level_per_wave)

    DEBUG_WAVE_CONFIG.SET(wave, level)

    -- ? NOTE: DON"T optimize early, just build a bunch of waves. Leave balace for last!!!!!
    -- ? NOTE: start with hard mobs first and reduce difficulty.

    -- ? NOTE: Each wave introcuces something new, introduces a new mechanic.

    -- ? NOTE: Make sure waves feel different and unique.

    -- Zombie waves 1 2 3
    table.insert(WAVE_DATA,
        Wave(
            {
                -- ? NOTE: Teaches controls shootings and basic mechanics.

                WaveEnemyEntryModTime(EnemyZombieShip, 4, ZOMBIE["GREEN_BASE"], 60),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["GREEN_BASE"], 60 * 4, 60 * 2),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                -- ? NOTE: Teaches about enemy types

                WaveEnemyEntryModTime(EnemyZombieShip, 2, ZOMBIE["BLUE_BASE_SLOW"], 60),
                WaveEnemyEntryOnTrigger(EnemyShooter, 1, SHOOTER["GREEN_BASE"], TRIGGER.WITH_3_AT_1_4_TIME),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                -- ? NOTE: Introducing to boss mechanics
                WaveEnemyEntryOnStart(EnemyZombieShip, 1, ZOMBIE["BOSS_1"]),
                WaveEnemyEntryOnTrigger(EnemyZombieShip, 1, ZOMBIE["BOSS_2"], TRIGGER.AT_50),

                WaveEnemyEntryAlways(EnemyMedusa,  1, MEDUSA["GREEN_BASE"], 60*3),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["GREEN_BASE"], 60*10),
            },
            true
        )
    )

    -- Wall Waves 4 5 6
    table.insert(WAVE_DATA,
        Wave(
            {
                --- ? Boring level, needs somthing
                WaveEnemyEntryOnStart(EnemyPeek, 1, PEEK["GREEN_BASE_MID"]),
                WaveEnemyEntryOnTrigger(EnemyPeek, 1, PEEK["GREEN_BASE_MID"], TRIGGER.WITH_2_AT_1_3_TIME),

                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["GREEN_BASE"], 60),
                WaveEnemyEntryTimed(EnemyShooter, 1, SHOOTER["GREEN_BASE"], 60*4),

                WaveEnemyEntryAlways(EnemyMedusa,  1, MEDUSA["GREEN_BASE"], 60*3),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyPeek, 2, PEEK["GREEN_BASE"]),
                WaveEnemyEntryTimed(EnemyPeek, 2, PEEK["GREEN_BASE"], 60*7),

                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["BLUE_BASE"]),
                WaveEnemyEntryTimed(EnemyShooter, 1, SHOOTER["BLUE_BASE"], 60*5),

                WaveEnemyEntryOnTrigger(EnemyMedusa,  1, MEDUSA["GREEN_BASE"], TRIGGER.WITH_3_AT_1_4_TIME)
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyPeek, 1, PEEK["BOSS"]),
                WaveEnemyEntryTimed(EnemyMedusa,  1, MEDUSA["GREEN_BASE_P2"], 60*7),
                WaveEnemyEntryModTime(EnemyZombieShip, 2, ZOMBIE["BLUE_BASE"], 40),
                WaveEnemyEntryModTime(EnemyZombieShip, 3, ZOMBIE["BLUE_BASE"], 80)
            },
            true
        )
    )

    -- kamikaze waves 7 8 9
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyKamikaze, 1, KAMIKAZE["GREEN_BASE"]),

                WaveEnemyEntryAlways(EnemyKamikaze, 2, KAMIKAZE["GREEN_BASE"], 60*4),
                WaveEnemyEntryAlways(EnemyKamikaze, 1, KAMIKAZE["GREEN_BASE"], 60*15, 30),

                WaveEnemyEntryAlways(EnemyMedusa,  1, MEDUSA["BLUE_BASE"], 60*4),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyPeek, 1, PEEK["GREEN_BASE"]),
                WaveEnemyEntryTimed(EnemyPeek, 3, PEEK["GREEN_BASE"], 60*7),

                WaveEnemyEntryAlways(EnemyKamikaze, 1, KAMIKAZE["GREEN_BASE"]),
                WaveEnemyEntryOnTrigger(EnemyKamikaze,  1, KAMIKAZE["GREEN_BASE"], TRIGGER.WITH_5_AT_1_6_TIME),

                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["YELLOW_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyKamikaze, 2, KAMIKAZE["BOSS"], 30, 10),

                WaveEnemyEntryAlways(EnemyMedusa, 1, MEDUSA["BLUE_BASE"], 120),
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["BLUE_BASE"], 180),
            },
            true
        )
    )


    -- bounce waves 10 11 12
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnTrigger(EnemySeeker, 1, SEEKER["GREEN_BASE_MID"], TRIGGER.AT_50),
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["GREEN_BASE"]),
                WaveEnemyEntryAlways(EnemyZombieShip, 4, ZOMBIE["YELLOW_BASE"]),
                WaveEnemyEntryTimed(EnemyPeek, 1, PEEK["BLUE_BASE"], 60*4),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["GREEN_IMMUNE"]),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["YELLOW_BASE"]),
                WaveEnemyEntryOnTrigger(EnemyMedusa,  1, MEDUSA["BLUE_BASE_P5"], TRIGGER.WITH_3_AT_1_4_TIME),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyPeek, 1, PEEK["BLUE_IMMUNE_MID"]),
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["BOSS"]),
                WaveEnemyEntryOnTrigger(EnemySeeker, 1, SEEKER["GREEN_BASE_IMMUNE"], TRIGGER.AT_10),

                WaveEnemyEntryOnTrigger(EnemySeeker, 1, SEEKER["GREEN_BASE_IMMUNE_ALT"], TRIGGER.AT_50)
            },
            true
        )
    )

    -- shooter waves 13 14 15
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["BLUE_BASE"]),
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["YELLOW_BASE"]),
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["WHITE_BASE"]),
            }
        )
    )

    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnTrigger(EnemySeeker, 1, SEEKER["GREEN_BASE_MID"], TRIGGER.WITH_2_AT_1_3_TIME),
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["BLUE_BASE"]),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["WHITE_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["BOSS"], 60),
                WaveEnemyEntryTimed(EnemyKamikaze, 1, KAMIKAZE["BLUE_BASE"], 300),
                WaveEnemyEntryTimed(EnemyMedusa,  1, MEDUSA["BLUE_BASE_M2_P5"], 400),
            },
            true
        )
    )

    -- good so far

    -- medusa waves 16 17 18
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyMedusa, 1, MEDUSA["BLUE_BASE_M9_P8"]),
                WaveEnemyEntryTimed(EnemyMedusa, 1, MEDUSA["YELLOW_BASE_M3_P6"], 60*4),
                WaveEnemyEntryAlways(EnemySeeker, 1, SEEKER["YELLOW_BASE"], 60*8),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyMedusa, 1, MEDUSA["YELLOW_BASE_M3_P6"]),
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["YELLOW_BASE"], 60*2),

                WaveEnemyEntryOnTrigger(EnemyMedusa, 1, MEDUSA["BLUE_BASE_M12_P8"], TRIGGER.WITH_3_AT_1_4_TIME),
                WaveEnemyEntryOnTrigger(EnemyPeek, 2, PEEK["YELLOW_BASE"], TRIGGER.AT_50),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemySeeker, 2, SEEKER["BLUE_BASE"], 60*5),

                WaveEnemyEntryAlways(EnemyMedusa, 1, MEDUSA["BOSS"]),
                WaveEnemyEntryTimed(EnemyMedusa, 1, MEDUSA["PURPLE_BASE_BOSS"], 60*6),
            },
            true
        )
    )

    -- oganic waves 19 20 21
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyOrganic, 1, ORGANIC["GREEN_BASE"]),
                WaveEnemyEntryOnTrigger(EnemyMedusa,  1, MEDUSA["YELLOW_BASE_M10_P3"], TRIGGER.WITH_2_AT_1_3_TIME),
                WaveEnemyEntryAlways(EnemyZombieShip, 4, ZOMBIE["RED_BASE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyOrganic, 1, ORGANIC["GREEN_BASE"], 60),
                WaveEnemyEntryOnTrigger(EnemyKamikaze, 1, KAMIKAZE["WHITE_BASE"], TRIGGER.WITH_4_AT_1_5_TIME),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["RED_BASE"], 60*3),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyOrganic, 1, ORGANIC["BOSS"]),
            },
            true
        )
    )

    -- seeker waves
    -- waves 22 23 24
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["YELLOW_BASE"], 30),
                WaveEnemyEntryTimed(EnemySeeker, 1, SEEKER["YELLOW_BASE"], 60*2),

                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["PURPLE_BASE"], 60*2)
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemySeeker, 2, SEEKER["RED_BASE"], 60*1+30),
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["WHITE_BASE_SLOW"], 60*3),
                WaveEnemyEntryTimed(EnemyPeek, 1, PEEK["FUSION_BASE_S3"], 60*10)
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemySeeker, 1, SEEKER["BOSS"], 45),
                WaveEnemyEntryTimed(EnemyMedusa, 1, MEDUSA["YELLOW_BASE_M10_P3"], 60*14)
            },
            true
        )
    )


    -- challenge waves
    -- set of waves combining everying, no bosses
    -- waves 25 26 27
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["BLUE_BASE_SPECIAL"], 25),
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["YELLOW_BASE_SPECIAL"], 25),
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["RED_BASE_SPECIAL"], 25),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyZombieShip, 1, ZOMBIE["RED_BASE_M2"], 60*3),
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["RED_BASE"]),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["WHITE_BASE"]),
                WaveEnemyEntryOnTrigger(EnemyMedusa, 1, MEDUSA["WHITE_BASE_M2_P16"], TRIGGER.WITH_2_AT_1_3_TIME),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyPeek, 1, PEEK["FUSION_BASE_S3"], 120),
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["RED_BASE_WALL"], 80),
                WaveEnemyEntryOnTrigger(EnemyMedusa,  1, MEDUSA["RED_BASE"], TRIGGER.WITH_5_AT_1_6_TIME),
            }
        )
    )
    -- 28 29 30
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryTimed(EnemyKamikaze, 1, KAMIKAZE["PURPLE_BASE"], 220),
                WaveEnemyEntryAlways(EnemyMedusa, 1,  MEDUSA["WHITE_BASE_BLOCK"])
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryTimed(EnemySeeker, 1, SEEKER["RED_BASE"], 285),
                WaveEnemyEntryAlways(EnemyBounce, 3, BOUNCE["IMMUNE"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["WHITE_BASE"]),
                WaveEnemyEntryAlways(EnemyShooter, 1, SHOOTER["FUSION_BASE"]),
                WaveEnemyEntryOnTrigger(EnemyKamikaze, 1, KAMIKAZE["WHITE_BASE"], TRIGGER.WITH_4_AT_1_5_TIME)
            }
        )
    )
    -- 31 32 33
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyMedusa, 2,  MEDUSA["FUSION_BASE_M6_P16"]),
                WaveEnemyEntryTimed(EnemyZombieShip, 1, ZOMBIE["WHITE_BASE"], 25),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryTimed(EnemyPeek, 1, PEEK["RED_BASE"], 450),
                WaveEnemyEntryAlways(EnemyOrganic, 1, ORGANIC["FUSION_BASE_M2"]),
                WaveEnemyEntryAlways(EnemyBounce, 5, BOUNCE["YELLOW_BASE"], 300)
            }
        )
    )

    -- Quasar waves
    local base = 1/11
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnTrigger(EnemyZombieShip, 1, ZOMBIE["QUASAR_WALL"],
                    trigger_table(
                        base * 1, 
                        base * 2, 
                        base * 3, 
                        base * 4, 
                        --base * 5,
                        base * 6, 
                        base * 7, 
                        base * 8, 
                        --base * 9,
                        base * 10,
                        base * 11,
                        base * 12, 
                        base * 13, 
                        base * 14, 
                        base * 15,
                        base * 16, base * 17, base * 18, base * 19, base * 20,
                        base * 21, base * 22, base * 23, base * 24, base * 25,
                        base * 26, base * 27, base * 28, base * 29, base * 30
                    )),
                WaveEnemyEntryOnTrigger(EnemyZombieShip, 1, ZOMBIE["QUASAR_BIG"],
                    trigger_table(
                        base * 5, base * 9
                    ))
            },
            -- set boss mode
            false,
            -- set quasar mode
            true
        )
    )

    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryTimed(EnemyPeek, 1, PEEK["QUASAR"], 60*1),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["QUASAR_WALL"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyMedusa, 1, MEDUSA["QUASAR_1"]),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["QUASAR_SUPPORT"], 90),
                WaveEnemyEntryAlways(EnemyMedusa, 1, MEDUSA["QUASAR_2"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyKamikaze, 1, KAMIKAZE["QUASAR"]),

                WaveEnemyEntryModTime(EnemyKamikaze, 1, KAMIKAZE["QUASAR"], 59),
                WaveEnemyEntryModTime(EnemyKamikaze, 1, KAMIKAZE["QUASAR"], 79),
                WaveEnemyEntryModTime(EnemyKamikaze, 1, KAMIKAZE["QUASAR"], 101),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyShooter, 8, SHOOTER["QUASAR_1"]),
                WaveEnemyEntryAlways(EnemyShooter, 2, SHOOTER["QUASAR_2"]),
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyBounce, 2, BOUNCE["QUASAR_1"], 200),
                WaveEnemyEntryAlways(EnemyBounce, 1, BOUNCE["QUASAR_2"], 200),
                WaveEnemyEntryAlways(EnemyZombieShip, 10, ZOMBIE["QUASAR_SUPPORT"])
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryAlways(EnemyOrganic, 2, ORGANIC["QUASAR"]),
                WaveEnemyEntryOnTrigger(EnemyOrganic, 1, ORGANIC["QUASAR"], TRIGGER.WITH_2_AT_1_3_TIME)
            }
        )
    )
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemySeeker, 1, SEEKER["QUASAR"]),
                WaveEnemyEntryTimed(EnemyMedusa, 1, MEDUSA["WHITE_BASE_M2_P16"], 350)
            }
        )
    )
    --- 
    table.insert(WAVE_DATA,
        Wave(
            {
                WaveEnemyEntryOnStart(EnemyHeart, 1, {})
            },
            true
        )
    )
end
