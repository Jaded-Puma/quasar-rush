-- Basic 2d array class

Array2d = lazy.class("Array2d")

function Array2d:constructor(w, h, default_value)
  self.default_value = default_value
  self.w = w
  self.h = h

  self.array = {}

  for x=1,w do
    ---@type table
    self.array[x] = {}

    for y=1,h do
      self.array[x][y] = self.default_value
    end
  end
end

function Array2d:set(x, y, value)
  self.array[x][y] = value
end

function Array2d:get(x, y)
  return self.array[x][y]
end

--- clear array with default values
function Array2d:clear()
  for x=1,self.w do
    for y=1,self.h do
    self.array[x][y] = self.default_value
    end
  end
end

--- loop through array with fun(value, x, y)
function Array2d:loop(loopfunc)
  for x=1,self.w do
    for y=1,self.h do
      loopfunc(self.array[x][y], x, y)
    end
  end
end
