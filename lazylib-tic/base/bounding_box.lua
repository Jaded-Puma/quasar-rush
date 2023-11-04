-- a BoundingBox designed to handle collisions

BoundingBox = lazy.class("BoundingBox")

function BoundingBox:constructor(x, y, w, h) 
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function BoundingBox:apply(x, y)
    return self.x + x, self.y + y, self.w, self.h
end