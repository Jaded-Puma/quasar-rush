-- Abstract Entity class

Entity = lazy.class("Entity")

function Entity:constructor(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.r = 0
  self.ox = w / 2
  self.oy = h / 2
  self.sx = 1
  self.sy = 1

  self.color = {1, 1, 1, 1}

  self.bounding_boxes = {}

  self.delete = false
end

--- @deprecated
function Entity:getScaledRectangle()
  local w, h = math.floor(self.w * self.sx), math.floor(self.h * self.sy)
  local ox, oy = w / 2, h / 2
  return self.x - ox, self.y - oy, w, h, ox, oy
end

function Entity:update(dt)
  error(self._class_name.." does not override :update(dt) from Entity class")
end

function Entity:render()
  error(self._class_name.." does not override :render() from Entity class")
end

function Entity:addBoundingBox(name, rx, ry, w, h)
  self.bounding_boxes[name] = BoundingBox(rx, ry, w, h)
end

function Entity:getBoundingBox(name)
  return self.bounding_boxes[name]
end