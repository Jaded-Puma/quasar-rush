-- Basic animation class with a lot of limitations.

Animation = lazy.class("Animation")

function Animation:constructor(animation_data)
  self.data = animation_data.data
  self.index = ""
  
  self.time = 0
  self.frame = 1
end

-- this starts a specific animation
function Animation:start(index)
  self.index = index
  self.frame = 1
  self.time = self.data[self.index].frames[self.frame].ticks
end

function Animation:update()
  self.time = self.time - 1
  
  if self.time == 0 then
    if self.data[self.index].loop then
      if self.frame ~= #self.data[self.index].frames then
        self.frame = self.frame + 1
      else
        self.frame = 1
      end
    else
      if self.frame ~= #self.data[self.index].frames then
        self.frame = self.frame + 1
      else
        -- ignore / end on non-looping animation
      end
    end
    
    self.time = self.data[self.index].frames[self.frame].ticks
  end
end

function Animation:draw(...)
  self.id = self.data[self.index].frames[self.frame].id
  spr(self.id, ...)
end
