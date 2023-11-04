-- Data for Animation class

AnimationData = lazy.class("AnimationData")

--- Animation constrcutor
-- The animation constrcutor takes in any number of parameters
function AnimationData:constructor(...)
  local args = { ... }

  for _, anim in ipairs(args) do
    if type(anim[1]) ~= "string" then error("Incorrect animation data, expected string") end

    local anim_name = anim[1]
    for i = 2,#anim do
      
    end
  end
  -- local state = 1 -- 1:string 2:frame/time or bool to end
  -- local index = ""

  -- self.data = {}

  -- for i, v in ipairs(args) do

  --   -- get string name of animation
  --   if state == 1 then
  --     assert(type(v) == "string", "tic.animation_data expected a string value but got " .. type(v))

  --     index = v
  --     self.data[index] = {}
  --     self.data[index].frames = {}
  --     state = 2
  --   elseif state == 2 then
  --     if type(v) == "table" then
  --       assert(type(v[1]) == "number" and type(v[2]) == "number", "Incorrect number paramenters in tic.animation_data.")
  --       table.insert(self.data[index].frames, { id = v[1], ticks = v[2] })
  --     elseif type(v) == "boolean" then
  --       self.data[index].loop = v
  --       state = 1
  --     else
  --       error("Incorrect data type in tic.animation_data: " .. type(v))
  --     end
  --   end
  -- end
end
