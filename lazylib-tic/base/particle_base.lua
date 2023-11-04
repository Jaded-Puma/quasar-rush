-- Particle base class

ParticleBase = lazy.extend("ParticleBase", Entity)

function ParticleBase:constructor(x, y, dir_v, init_vel, acc)
    self.dir_v = dir_v
    self.init_vel = init_vel
    self.acc = acc

    ParticleBase.super:initialize(
        self,
        x, y,
        1, 1
    )
end