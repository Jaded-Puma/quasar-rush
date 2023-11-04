Particle = lazy.extend("Particle", ParticleBase)

-- TODO: needs reference to game_logic
function Particle:constructor(x, y, dir_v, init_vel, acc, maxtime, color_table)
    self.maxtime = maxtime
    self.time = 0
    self.color_table = color_table

    self.vel = init_vel

    self.doubled = (math.random() < 0.2)

    Particle.super:initialize(
        self,
        x, y,
        dir_v, init_vel, acc
    )
end

function Particle:update(dt)
    self.time = lazy.math.bound(self.time + 1, 0, self.maxtime)

    -- TODO: needs reference to camera

    if self.time == self.maxtime then
        self.delete = true
    end

    self.x = self.x + self.dir_v.x * self.vel
    self.y = self.y + self.dir_v.y * self.vel

    self.vel = self.vel + self.acc

    if self.x < 0 or self.x > CONFIG.GAME.VIEWPORT.W 
    or self.y < 0 or self.y > CONFIG.GAME.VIEWPORT.H then
        self.delete = true
    end
end

function Particle:render()
    local index = 1 + lazy.math.round( self.time/self.maxtime * (#self.color_table - 1))

    if self.doubled then
        rect(self.x, self.y, 2, 2, self.color_table[index])
    else
        pix(self.x, self.y, self.color_table[index])
    end
end