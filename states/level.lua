-- Container class for logic anbd renderer for "level"

StateLevel = lazy.extend("StateLevel", State)

function StateLevel:constructor()
    self.logic = StateLevelLogic(self)
    self.renderer = StateLevelRenderer(self.logic)
end

function StateLevel:start()
    self.logic:start()
end

function StateLevel:update(dt)
    self.logic:update(dt)
end

function StateLevel:render()
    self.renderer:render()
end

function StateLevel:overlay()
    self.renderer:overlay()
end