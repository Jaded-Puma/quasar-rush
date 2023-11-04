local UPGRADE_TYPE = lazy.enum(
    "PLUS_WEAPON"
)

UPGRADE = {
    SPACESHIP = {
        [1] = {
            LEVEL = {
                [5]  = UPGRADE_TYPE.PLUS_WEAPON,
                [25] = UPGRADE_TYPE.PLUS_WEAPON,
                [50] = UPGRADE_TYPE.PLUS_WEAPON,
                [99] = UPGRADE_TYPE.PLUS_WEAPON,
            },
        }
    },

    apply = function(spaceship, ball)

        local a = spaceship.logic.level / CONFIG.SPACESHIP.MAX_LEVEL
        local t = a

        -- upgrade stats
        ball.logic.tap_speed_mod = CONFIG.SPACESHIP.MAX_UPGRADE.MOVE_SPEED * t
        spaceship.logic.attack_timeout_mod = lazy.math.round(CONFIG.SPACESHIP.MAX_UPGRADE.ATTACK_RATE * t)
        spaceship.logic.projectile_speed_mod = CONFIG.SPACESHIP.MAX_UPGRADE.BULLET_SPEED * t

        -- unique upgrades
        local LEVEL = UPGRADE.SPACESHIP[1].LEVEL
        local unique_upgrade = LEVEL[spaceship.logic.level]
        
        if unique_upgrade ~= nil 
        and unique_upgrade ==  UPGRADE_TYPE.PLUS_WEAPON
        then
            spaceship.logic.weapons =  spaceship.logic.weapons + 1
        end
    end,

    getText = function(spaceship)
        -- unique upgrades
        local unique_upgrade = UPGRADE.SPACESHIP[1].LEVEL[spaceship.logic.level]

        if spaceship.logic.level == CONFIG.SPACESHIP.MAX_LEVEL then
            return "MAX LEVEL"
        end

        if unique_upgrade ~= nil then
            if unique_upgrade ==  UPGRADE_TYPE.PLUS_WEAPON then
                return "+ WEAPON"
            else
                return "[nil]"
            end
        else
            return "LEVEL UP"
        end
    end
}