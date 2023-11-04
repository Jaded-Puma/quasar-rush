-- Camera class to handle scrolling and camera effects

Camera = lazy.class("Camera")

function Camera:constructor(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.intensity = 0
    self.duration = 0
    self.shake_timer = 0
    self.xs = x
    self.ys = y
end

function Camera:update(dt)
    if self.shake_timer ~= 0 then 
        self.shake_timer = self.shake_timer - 1

        local a = 1 - self.shake_timer / self.duration
        local t = 1 - lazy.tween.func.easeInQuart(a)

        local shake_x = lazy.math.round(((math.random() * 2) - 1) * self.intensity * t)
        local shake_y = lazy.math.round(((math.random() * 2) - 1) * self.intensity * t)

        self.xs = self.x + shake_x
        self.ys = self.y + shake_y
    else
        self.xs = self.x
        self.ys = self.y
    end
end

function Camera:shake(intensity, duration)
    self.intensity = intensity
    self.duration = duration
    self.shake_timer = duration
end