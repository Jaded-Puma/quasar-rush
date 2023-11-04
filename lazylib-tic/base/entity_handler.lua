-- A somewhat inefficient way to store "Entity" objects.

EntityHandler = lazy.class("EntityHandler")

-- TODO: sort function

function EntityHandler:constructor(limit)
  self.limit = limit or -1

  -- assert(limit == -1 or limit > 1, "EntityHandler limit must be greater than 1 or -1")

  self.list = {}
end

--- Clears the enitity list
function EntityHandler:clear()
  self.list = {}
end

function EntityHandler:size()
  return #self.list
end

function EntityHandler:isEmpty()
  return #self.list == 0
end

function EntityHandler:add(entity)
  if self.limit > 0 and #self.list == self.limit then return end

  table.insert(self.list, entity)
end

function EntityHandler:get(index)
  return self.list[index]
end

function EntityHandler:remove(entity)
  for i,ref in ipairs(self.list) do
    if entity == ref then
      table.remove(self.list, i)
      break
    end
  end
end

function EntityHandler:removeAll()
  for i = #self.list, 1, -1 do
    if self.list[i].delete then
      table.remove(self.list, i)
    end
  end
end

function EntityHandler:update(dt)
  for _,entity in ipairs(self.list) do
    entity:update(dt)
  end

  -- remove expired
  for i = #self.list, 1, -1 do
    if self.list[i].delete then
      table.remove(self.list, i)
    end
  end
end

function EntityHandler:render()
  for _,entity in ipairs(self.list) do
    entity:render()
  end
end

function EntityHandler:loop(func)
  for _,entity in ipairs(self.list) do
    func(entity)
  end
end

function EntityHandler:sort(func)
  table.sort(self.list, func)
end

function EntityHandler:render_debug()
  for _,entity in ipairs(self.list) do
    entity:render_debug()
  end
end
