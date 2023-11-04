ControlBallEntityLogic = lazy.extend("ControlBallEntityLogic", Entity)

function ControlBallEntityLogic:constructor(entity)
    self.control_box_x = 0
    self.control_box_y = 120 - 16
    self.control_box_w = 200
    self.control_box_h = 16 + 16

    self.entity = entity

    self.min_x = 0
    self.max_x = 200

    self.tap_x = self.entity.x

    self.tap_hold = false

    self.default_tap_speed = CONFIG.SPACESHIP.MOVE_SPEED
    self.tap_speed = self.default_tap_speed

    self.tap_speed_mod = 0
end

function ControlBallEntityLogic:update(dt)
    self.tap_hold = false

    if CURSOR.left then
        if lazy.util.is_point_inside_box(CURSOR.x, CURSOR.y,
                self.control_box_x, self.control_box_y,
                self.control_box_w, self.control_box_h) then
            self.tap_hold = true
        end
    else
        self.tap_hold = false
        self.tap_x = self.entity.x
    end
    

    if self.tap_hold then
        self.tap_x = lazy.math.bound(CURSOR.x-8, self.min_x, self.max_x-16)
        local w = math.sqrt((self.tap_x - self.entity.x)^2)
        local sign = lazy.math.sign(self.tap_x - self.entity.x)
        self.entity.x = self.entity.x + sign * (self.default_tap_speed + self.tap_speed_mod)

        if sign > 0 then
            self.entity.x = lazy.math.bound(self.entity.x, 0, self.tap_x)
        else
            self.entity.x = lazy.math.bound(self.entity.x, self.tap_x, self.max_x)
        end
    end
end