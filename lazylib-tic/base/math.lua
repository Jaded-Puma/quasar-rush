-- Extended math utility API

local maths = {}
lazy.math = maths

local PI2 = math.pi * 2

local min, max, abs, sqrt = math.min, math.max, math.abs, math.sqrt

---@param a number
---@param start number
---@param finish number
---@return number
maths.lerp = function(a, start, finish)
  return start + (finish - start) * a
end

maths.nlerp = function(func, start, finish, value)
  local x = (value - start) / (finish - start)
  local a = func(x)
  return start + (finish - start) * a
end

maths.remap = function() end -- x -> converts min to max to map min to max

--- return the sign of the number as 1 or -1
---@param value number
---@return number
function maths.sign(value)
	return (value >= 0 and 1) or -1
end

maths.random_sign = function ()
  if math.random() <= 0.5 then 
    return 1
  else
    return -1
  end
end

-- round number to nearest bracket
---@param value number
---@param bracket number @express the value as e.x. 10 to round up, or e.x. 0.1 to round down.
---@return number
---@overload fun(value: number): number
function maths.round(value, bracket)
	bracket = bracket or 1
	return math.floor(value /bracket + maths.sign(value) * 0.5) * bracket
end

--- bound the value to a range
---@param value number
---@param low number
---@param high number
---@return number
maths.bound = function(value, low, high)
  if value < low then
    return low
  elseif value > high then
    return high
  else
    return value
  end
end

maths.lower_bound = function(value, low)
  if value < low then
    return low
  else
    return value
  end
end

maths.upper_bound = function (value, high)
  if value > high then
    return high
  else
    return value
  end
end

maths.distance = function(x0, y0, x1, y1)
  local dx = x1 - x0
  local dy = y1 - y0

  dx, dy = abs(dx), abs(dy)

  return max(dx, dy) * 0.9609 + min(dx, dy) * 0.3984
end

--- calculate normal vector from two points
---@param x0 number
---@param y0 number
---@param x1 number
---@param y1 number
---@return table
maths.normal = function(x0, y0, x1, y1)
  local dx = x1 - x0
  local dy = y1 - y0

  local m = math.sqrt(dx^2 + dy^2)

  return {x = dx/m, y = dy/m}
end

--- takes in angle in degrees and return normal
maths.normalAngleDegree = function(theta)
  local rads = math.rad(theta)
  return {x = math.cos(rads), y = math.sin(rads)}
end

maths.normalAngleRad = function(theta)
  return {x = math.cos(theta), y = math.sin(theta)}
end


maths.normalizeAngleRad = function(angle) 
  while angle < 0 do angle = angle + PI2 end
  while angle >= PI2 do angle = angle - PI2 end
  return angle
end

maths.rollingAverage = function(avg, new_sample, n)
  avg = avg - avg / n;
  avg = avg + new_sample / n;
  return avg;
end