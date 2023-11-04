--- An animation class using modulus
-- An fast way to do an animation using modulus
-- this method makes all frames take the same time
-- and it's very inacurrate.
ModAnimate = lazy.class("ModAnimate")

-- TODO add sync for synced animation

function ModAnimate:constructor(ids, frame_time, tile)
    self.ids = ids
    self.frame_time = frame_time
    self.total_time = frame_time * #ids

    self.offset = math.random(0, self.total_time)

    self.tile = tile or 1
end

--- Renders the animation
--- @param frame_total number the total number of frames since application started
--- @param x number the x coordinate to draw the sprite
--- @param y number the y coordinate to draw the sprite
--- @param size number|nil the y coordinate to draw the sprite
--- @param flip number|nil optional draw flip
function ModAnimate:render(frame_total, x, y, size, flip)
    size = size or 1
    flip = flip or 0

    frame_total = frame_total + self.offset
    local current_frame = 1 + lazy.math.round((frame_total % self.total_time) / self.total_time * (#self.ids - 1))
    local current_id = self.ids[current_frame]

    spr(
        current_id,
        x, y,
        0, size, flip, 0,
        self.tile, self.tile
    )
end

function ModAnimate:renderFrame(index, x, y, size, flip)
    size = size or 1
    flip = flip or 0
    --index = (index > #self.ids and #self.ids or index)
    local current_id = self.ids[index]

    spr(
        current_id,
        x, y,
        0, size, flip, 0,
        self.tile, self.tile
    )
end