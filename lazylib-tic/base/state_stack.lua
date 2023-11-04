-- State stack class

StateStack = lazy.class("StateStack")

-- TODO: Proper implementation

function StateStack:constructor()
 self.stack = {}
end


function StateStack:push(state)
 table.insert(self.stack, state)
 state:start()
end

function StateStack:pop()
 assert(#self.stack > 0, "State stack cannot perform more 'pop()' operations.")
 local state = table.remove(self.stack)
 state:finish()
end


function StateStack:update()
 if #self.stack>0 then
  self.stack[#self.stack]:update()
 else
  self.state:update()
 end
end

function StateStack:render()
 self.state:render()
 
 if #self.stack>0 then
  for i=1,#self.stack do
   self.stack[i]:render()
  end
 end
end

function StateStack:overlay()
  self.state:overlay()
 
 if #self.stack>0 then
  for i=1,#self.stack do
   self.stack[i]:overlay()
  end
 end
end

function StateStack:scanline(scanline)
 if #self.stack>0 then
  self.stack[#self.stack]:scanline(scanline)
 else
  self.state:scanline(scanline)
 end
end
