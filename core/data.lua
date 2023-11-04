DATA = {}

-- temp vars
local t = 0

local shake_config = function(intensity, duration)
    return {
        intensity = intensity,
        duration  = duration,

        shake = function(self, camera)
            camera:shake(self.intensity, self.duration)
        end
    }
end

-- Number to sprite data
-- convert decimal to sprite table
DATA.SPR_NUM = {502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 486, 487}

-- GFX data
DATA.GFX = {}

t = 5
DATA.GFX.EXPLOSION = AnimationSingleData(
    {384, 386, 388, 390},
    {t,  t+3,  t+6,  t+9},
    2
)
t = 1
DATA.GFX.EXPLOSION_KAMIKAZE = AnimationSingleData(
    {392, 394, 396, 398},
    {t+6,  t+6,  t+3,  t+3},
    2
)

-- SFX data
DATA.SFX = {}

DATA.SFX.INDEX = {
    BULLET_FIRE = "bullet_fire",
    BULLET_COLLIDE = "bullet_collide",
    EXPLODE = "explode",
    EXP_COLLECT = "exp_collect",
    LEVELUP = "levelup",
    ENEMY_BULLET = "enemy_bullet",
    HEALTH_UP = "health_up",
    BOUNCE = "bounce",
    EYE_BULLET = "eye_bullet",
    IMMUNE_BULLET = "immune_bullet",
    FOLLOW_BULLET = "follow_bullet"
}

-- SFX
-- channel 2
DATA.SFX[DATA.SFX.INDEX.BULLET_COLLIDE] = SfxData(1, "F#1", nil, nil, 5, 2, 1000)
DATA.SFX[DATA.SFX.INDEX.IMMUNE_BULLET]  = SfxData(9, "D#3", nil, nil, 8, 2, 1000)
DATA.SFX[DATA.SFX.INDEX.EXP_COLLECT]    = SfxData(3, "C#5", nil, nil, 7, 2, 1010)
DATA.SFX[DATA.SFX.INDEX.HEALTH_UP]      = SfxData(6, "C#5", nil, nil, 7, 2, 1010)
DATA.SFX[DATA.SFX.INDEX.LEVELUP]        = SfxData(4, "C#4", nil, nil, 0, 2, 1020)

-- channel 3
DATA.SFX[DATA.SFX.INDEX.BULLET_FIRE]    = SfxData(0, "D#3", nil, nil, 6, 3, 1000)
DATA.SFX[DATA.SFX.INDEX.EXPLODE]        = SfxData(2, "A-1", nil, nil, 4, 3, 1020)
DATA.SFX[DATA.SFX.INDEX.ENEMY_BULLET]   = SfxData(5, "C-6", nil, nil, 6, 3, 1030)
DATA.SFX[DATA.SFX.INDEX.BOUNCE]         = SfxData(7, "C-3", nil, nil, 5, 3, 1030)
DATA.SFX[DATA.SFX.INDEX.EYE_BULLET]     = SfxData(8, "B-1", nil, nil, 8, 3, 1040)
DATA.SFX[DATA.SFX.INDEX.FOLLOW_BULLET]  = SfxData(11, "A-2", nil, nil, 8, 3, 1040)

-- MUSIC
DATA.TRACK = {}

DATA.TRACK.SPACE = 0
DATA.TRACK.INTRO = 1
DATA.TRACK.QUASAR = 2
DATA.TRACK.BOSS = 3

-- camera
DATA.CAMERA = {
    ENEMY_EXPLOSION = shake_config(1, 10),
    SHIP_COLLIDE_SHIP = shake_config(1, 10),
    SHIP_COLLIDE_PROJECTILE = shake_config(1, 10),
}


