-- Configuration data for game logic

local SPACESHIP_DOWN_SPREAD = 60
local SPACESHIP_UP_SPREAD = 17

local SHOOTER_M2_SPREAD = 25

-- local SPACESHIP_BASE_HP = 1000

local CONVERT_PAL = function(indexes, values)
    local pal = {}
    for i = 0, 15 do
        table.insert(pal, i)
    end

    for i, pal_index in ipairs(indexes) do
        pal[pal_index+1] = values[i]
    end

    return pal
end

local SAME_COLOR_PAL = function(color)
    local pal = {}
    for i = 0, 15 do
        table.insert(pal, color)
    end
    return pal
end

CONFIG = {
    GAME = {
        FPS = 60,
        SCREEN = {
            W = 240,
            H = 136
        },
        VIEWPORT = {
            X = 0,
            Y = 0,
            W = 200,
            H = 120
        }
    },
    UI = {
        WAVE_NUM_PAL = {0, 1, 2, 3, 4, 3, 6, 14, 8, 9, 10, 11, 12, 13, 14, 15},
        SCORE_NUM_PAL = {0, 1, 2, 3, 4, 7, 6, 14, 8, 9, 10, 11, 12, 13, 14, 15},
        SCORE_TOP_NUM_PAL = {0, 1, 2, 3, 4, 2, 6, 5, 8, 9, 10, 11, 12, 13, 14, 15},

        TRANSITION_TIME = 18,

        UI_DEFAULT_PAL = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15},

        UI_HURT_PAL = CONVERT_PAL(
            {7},
            {10}
        ),

        UI_BOSS_PAL = CONVERT_PAL(
            {7, 11},
            {3, 9}
        ),
    },
    GLOBAL = {
        KEY_HITBOX = "HITBOX",

        FLASH_TIME = 5,
        FLASH_PALATTE = {0, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15},

        PAL_DEFAULT = {0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 11, 12, 13, 14, 15},

        PAL_MODE = {
            --    {0, 1, 2, 3, 4, 5, 6, L, 8, 9, 10, D, 12, 13, 14, 15},
            -- d / l - 11 / 7

            -- default green
            [1] = {0, 1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 11, 12, 13, 14, 15},
            -- blue l /d 8 / 13
            [2] = {0, 1, 2, 3, 4, 5, 6, 8,  8, 9, 10, 13, 12, 13, 14, 15},
            -- yellow d / l 14 /9
            [3] = {0, 1, 2, 3, 4, 5, 6, 9,  8, 9, 10, 14, 12, 13, 14, 15},
            -- red
            [4] = {0, 1, 2, 3, 4, 5, 6, 10, 8, 9, 10, 3,  12, 13, 14, 15},
            -- purple
            [5] = {0, 1, 2, 3, 4, 5, 6, 6,  8, 9, 10, 4,  12, 13, 14, 15},
            -- white
            [6] = {0, 1, 2, 3, 4, 5, 6, 15, 8, 9, 10, 15, 12, 13, 14, 15},
            -- fusion
            [7] = CONVERT_PAL(
                {2, 7, 11},
                {4, 6, 14}),
            -- hard mode
            [8] = CONVERT_PAL(
                {1, 2, 5, 12},
                {6, 3, 10, 15}),
            -- hard mode pal
            -- TODO
            
            -- {0, 1, 2, 3, 4, 5, 6, 6,  8, 9, 10, 14, 12, 13, 14, 15},
        },

        IMMUNE_PAL = CONVERT_PAL(
            {1, 2, 5,  12},
            {2, 4, 12, 15}
        ),
        
        QUASAR_PAL = CONVERT_PAL(
            {8, 13, 15},
            {5, 8,  13}
        ),
        

        -- {0, 1, 4, 3, 4, 13, 6, 7, 8, 9, 10, 11, 15, 13, 14, 15},

        DAMAGE_COLLISION = 100,
        DAMAGE_PROJECTILE = 50,

        DAMAGE_COLLISION_PENALTY = 50,
        DAMAGE_PROJECTILE_PENALTY = 30,

        SCORE_MAX = 99999,

        SCORE = {
            SHIP_KILL = 1,
            EXP_ORB = 1,
            EXP_MAX_ORB = 4,
            HEART_ORB = 2,
            PER_WAVE = 10,
        },

        DROP_TYPE = lazy.enum("EXP", "LEVEL", "HEART"),

        DROP_RATE = {
            {1, 0, 0},
            {2, 23, 5},
            {3, 40, 5}
        },

        DROP_RATE_TEST    = {950, 40, 10},

        DROP_RATE_BASE    = {850, 50, 100},
        DROP_RATE_CORRUPT = {700, 100, 200},

        DROP_HEART_HEALTH = 400,

        
    },
    HARDMODE = {
        PAL = 8,
        HP_INCREASE = 30,
        HP_COR_INC = 100,
        HP_MUL = 0.8
    },
    LEVEL = {
        WAVE_TIMEOUT = 30 * 60,
        WAVE_BOSS_TIMEOUT = 45 * 60,
        WAVE_TEXT_TIMER_MAX = 100,
    },
    CONTROLBALL = {
        X = 10 * 8,
        Y = 15 * 8,
    },
    SPACESHIP = {
        Y = 96,

        HP = 1000,
        MOVE_SPEED = 1.1,
        EXP = 70,
        EXP_PER_CAPSULE = 10,

        MAX_LEVEL = 99,

        WEAPON_RECHARGE= 40,

        PICK_UP_RADIUS = 20,

        PROJECTILE_SPEED = 3.1,
        PROJECTILE_SIN_SPEED = 2.6,

        PROJECTILE_NORMAL_UP = lazy.math.normalAngleDegree(270),

        PROJECTILE_NORMAL_WEAPON1_LANE1 = lazy.math.normalAngleDegree(270),

        PROJECTILE_NORMAL_WEAPON2_LANE1 = lazy.math.normalAngleDegree(90 - SPACESHIP_DOWN_SPREAD),
        PROJECTILE_NORMAL_WEAPON2_LANE2 = lazy.math.normalAngleDegree(90 + SPACESHIP_DOWN_SPREAD),

        PROJECTILE_NORMAL_WEAPON3_LANE1 = lazy.math.normalAngleDegree(270 - SPACESHIP_UP_SPREAD),
        PROJECTILE_NORMAL_WEAPON3_LANE2 = lazy.math.normalAngleDegree(270 + SPACESHIP_UP_SPREAD),

        MAX_UPGRADE = {
            MOVE_SPEED   = 2.00,
            ATTACK_RATE  = -32,
            BULLET_SPEED = 1.33,
        },

        HITBOX = {
            X = 2,
            Y = 2+3,
            W = 12,
            H = 12-3
        }
    },
    ENEMY = {
        ZOMBIE_SHIP = {

            DAMAGE_COLLISION = 200, -- 5 kill

            DAMAGE_SIZE_2 = 400,

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        MEDUSA = {
            AMP = 36,

            DAMAGE_COLLISION = 100, --

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        KAMIKAZE = {
            SPAWN_HEIGHT_MIN = 10,
            SPAWN_HEIGHT_MAX = 35,

            DAMAGE_COLLISION = 250, -- 4 kill

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        SHOOTER = {
            MODE1_PROJ_NORMAL = lazy.math.normalAngleDegree(90),

            MODE2_PROJ_NORMAL1 = lazy.math.normalAngleDegree(90 - SHOOTER_M2_SPREAD),
            MODE2_PROJ_NORMAL2 = lazy.math.normalAngleDegree(90 + SHOOTER_M2_SPREAD),

            SPAWN_HEIGHT_MIN = 1,
            SPAWN_HEIGHT_MAX = 40,

            SHOOT_COOLDOWN = 25,
            SHOOT_ANTICIPATION = 35,
            SHOOT_BUFFER = 11,

            DAMAGE_PROJECTILE = 100, -- 10 kill

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        PEEK = {
            PEEK_TIME = 90,
            PEEK_AMOUNT = 16 * 3,
            ATTACK_TIME = 60*5,

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        ORGANIC = {
            AMP = 20,
            X_BUFFER = 14,
            ANGLE_TIME_MAX = 500,

            MOVE_SPEED_ANTICIPATION_MUL = 0,
            SHOOT_COOLDOWN = 25,
            SHOOT_ANTICIPATION = 35,


            DAMAGE_PROJECTILE = 200, -- 5 kill

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 29
            }
        },
        BOUNCE = {
            BOUNCE_COOLDOWN = 10,

            DAMAGE_COLLISION = 150, --

            HITBOX = {
                X = 2,
                Y = 2,
                W = 11,
                H = 11
            }
        },
        SEEKER = {

            DAMAGE_PROJECTILE = 100, -- 10 kill

            HITBOX = {
                X = 0,
                Y = 0,
                W = 8*3,
                H = 8
            }
        },
        HEART = {
            TRANS_TIME = 35,
            -- PAL_IN = {1, 2, 3, 10},
            -- PAL_OUT = {10, 3, 2, 1},

            PAL_INTRO = SAME_COLOR_PAL(10),

            DAMAGE_PROJECTILE = 200, -- 5 kill

            HITBOX = {
                X = 0+2,
                Y = 0+4+4,
                W = 31-2,
                H = 31-6-8
            }
        }
    }
}