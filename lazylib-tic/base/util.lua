-- Base utility API to simplify coding

local util = {}
lazy.util = util

util.position = function(x, y)
  local mt = {}
  local pos = {}
  pos.x = x
  pos.y = y

  mt.__tostring = function(self)
    return "{x="..self.x..", y="..self.y.."}"
  end

  setmetatable(pos, mt)
  return pos
end

util.dimension = function(w,h)
  local mt = {}
  local dim = {}
  dim.w = w
  dim.h = h
  mt.__tostring = function(self)
    return "{w="..self.w..", h="..self.h.."}"
  end
  setmetatable(dim, mt)
  return dim
end

-- Used for exiting nested loops with 'return'
util.loop = function(loopfunc)
  loopfunc()
end

util.align_horizontal = function(width_base, width_obj)
  return math.floor(width_base/2-width_obj/2)
end

util.align_vertical = function(height_base, hight_obj)
  return math.floor(height_base/2-hight_obj/2)
end

util.fif = function(test, if_true, if_false)
  if test then
    return if_true
  else
    return if_false
  end
end

util.is_point_inside_box = function(px, py, bx, by, bw, bh)
  return px > bx and px < bx+bw and py > by and py < by+bh
end

util.is_box_inside_box = function(x1, y1, w1, h1, x2, y2, w2, h2)
  -- return x2 < x1 + w1 and x2 + w2 > x1 and y2 > y1 + h1 and y2 + h2 < y1
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

util.entity_collision = function(e1, e2)
  return util.is_box_inside_box(e1.x, e1.y, e1.w, e1.h, e2.x, e2.y, e2.w, e2.h)
end

util.entity_collision_distance = function (e1, e2, dist)
  local dist_e = lazy.math.distance(e2.x, e2.y, e1.x, e1.y)

  return dist_e < dist
end

util.bouding_box_collision = function(key, e1, e2)
  local bb1 = e1:getBoundingBox(key)
  local bb2 = e2:getBoundingBox(key)

  local x1, y1, w1, h1 = bb1:apply(e1.x, e1.y)
  local x2, y2, w2, h2 = bb2:apply(e2.x, e2.y)

  return util.is_box_inside_box(x1, y1, w1, h1, x2, y2, w2, h2)
end

util.table_copy = function(to_table, from_table)
  for k,v in pairs(from_table) do
    to_table[k] = v
  end
end

util.single_state_action = function(state, state_var, Enum)
  for i,key_value in ipairs(lazy._enumdata[Enum]._reverse_ref) do
    if state_var == i then
      local func = state["_state_"..key_value]
      func(state)
      return
    end
  end

  error("State number "..tostring(state_var).." was not found in StateEnum")
end

-- Enum utility functions
util.enum = {}

util.enum.toString = function (Enum, value)
  local string_ref = lazy._enumdata[Enum]._reverse_ref[value]
  assert(string_ref ~= nil, "Enum value was not found.")
  return string_ref
end
