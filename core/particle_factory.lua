local data = function(maxtime, color_table)
    return {
        maxtime = maxtime,
        color_table = color_table
    }
end

local dir = function(x, y)
    return {
        x = x,
        y = y
    }
end

local generic_trail = function(handler, x, y, spread, data)
-- 4 x 4 size
    local new_x = x + math.random(0, spread)
    local new_y = y + math.random(0, spread)

    local _data = data

    local particle = Particle(new_x, new_y, dir(0, 0), 0, 0, _data.maxtime, _data.color_table)

    handler:add(particle)
end



local PARTICLE_DEFINITION = {}

PARTICLE_DEFINITION.BULLET = data(15, {15, 11, 7, 7, 2, 1})

PARTICLE_DEFINITION.BULLET_ENEMY = data(15, {15, 10, 6, 6, 3, 1})

PARTICLE_DEFINITION.AIM_ATTACK = data(60, {13, 13, 8, 8, 4, 2, 1})

PARTICLE_DEFINITION.BOUNCE = data(60, {10, 10, 9, 3, 3, 2})

PARTICLE_DEFINITION.DEBRIS = data(0, {12, 12, 5, 5, 5, 2, 2, 1})

PARTICLE_DEFINITION.QUASAR = data(0, {6, 6, 6, 5, 5, 2, 1, 1})

PARTICLE_FACTORY = {}



PARTICLE_FACTORY.bullet_trail = function(handler, x, y)
    generic_trail(handler, x, y, 4, PARTICLE_DEFINITION.BULLET)
end

PARTICLE_FACTORY.enemy_bullet_trail = function(handler, x, y)
    generic_trail(handler, x, y, 4, PARTICLE_DEFINITION.BULLET_ENEMY)
end

PARTICLE_FACTORY.aim_attack_trail = function(handler, x, y)
    generic_trail(handler, x, y, 2, PARTICLE_DEFINITION.AIM_ATTACK)
end

PARTICLE_FACTORY.bounce = function(handler, x, y)
    generic_trail(handler, x, y, 2, PARTICLE_DEFINITION.BOUNCE)
end

PARTICLE_FACTORY.explosion = function(handler, cx, cy)
    local t_min = 50
    local t_max = 70
    local t_dt = t_max - t_min

    local v_min = 0.1
    local v_max = 0.5
    local v_dt = v_max - v_min

    local acc = -0.0005

    local tau = 2 * math.pi

    -- calculate normal vector
    local angle = math.random() * tau
    local new_vx = math.cos(angle)
    local new_vy  = math.sin(angle)

    local color_table = PARTICLE_DEFINITION.DEBRIS.color_table

    local new_t =  t_min + math.random() * t_dt
    local new_vel = v_min + math.random() * v_dt
    
    local particle = Particle(cx, cy, dir(new_vx, new_vy), new_vel, acc, new_t, color_table)

    handler:add(particle)
end

PARTICLE_FACTORY.quasar = function(handler, cx, cy)
    local t_min = 120
    local t_max = 150
    local t_dt = t_max - t_min

    local v_min = 0.05
    local v_max = 0.24
    local v_dt = v_max - v_min

    local acc = 0.0005
    local tau = 2 * math.pi

    local angle = math.random() * tau
    local new_vx = math.cos(angle)
    local new_vy  = math.sin(angle)

    local color_table = PARTICLE_DEFINITION.QUASAR.color_table

    local new_t =  t_min + math.random() * t_dt
    local new_vel = v_min + math.random() * v_dt

    local particle = Particle(cx, cy, dir(new_vx, new_vy), new_vel, acc, new_t, color_table)

    handler:add(particle)
end