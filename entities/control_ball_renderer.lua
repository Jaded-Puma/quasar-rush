ControlBallEntityRenderer = lazy.extend("ControlBallEntityRenderer", Entity)

function ControlBallEntityRenderer:constructor(entity)
    self.entity = entity

    self.sid = 288
    self.w = 2
    self.h = 2
end

function ControlBallEntityRenderer:render()
    -- ball
    spr(
        self.sid, 
        self.entity.x, self.entity.y, 
        0, 1, 0, 0, 
        self.w , self.h
    )
end