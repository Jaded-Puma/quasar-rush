SfxEntity = lazy.extend("SfxEntity", Entity)

function SfxEntity:constructor(x, y, animation)
    self.x = x
    self.y = y
    self.animation = animation:getIntanced()
end

function SfxEntity:update(dt)
    self.animation:update(dt)

    if self.animation:isDone() then
        self.delete = true
    end
end

function SfxEntity:render()
    self.animation:render(self.x, self.y)
end