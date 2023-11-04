-- the base state class that is used by StateManager

-- State class
State = lazy.class("State")

State.constructor = function() end

State.start = function() end
State.finish = function() end
State.update = function(dt) end
State.render = function() end
State.scanline = function(scanline) end
State.overlay = function() end

