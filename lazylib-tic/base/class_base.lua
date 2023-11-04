-- Class implementation for Lua

lazy.class = function(class_name)

  local mt = {
    __call = function(ClassGeneric, ...)
      local instance = ClassGeneric:_instantiate()
      ClassGeneric.constructor(instance, ...)
      return instance
    end
  }

  local ClassDefinition = {
    super = nil,

    _class_name = class_name,

    constructor = function()
      error(class_name.." class called without a constructor.")
    end,

    _instantiate = function(ClassGeneric)
      local instance = {}
  
      instance._class_name = ClassGeneric._class_name
  

      for k,v in pairs(ClassGeneric) do
        if type(v) == "function" then
          if k ~= "constructor" and k ~= "_instantiate" and k ~= "initialize" then
            instance[k] = v
          end
        end
      end
  
      return instance
    end,

    initialize = function(SuperClass, instance, ...)
      SuperClass.constructor(instance, ...)
  
      ---@param k string
      for k,v in pairs(SuperClass) do
        if type(v) == "function" then
          if k ~= "constructor" and k ~= "_instantiate" and k ~= "initialize" then
            if not instance[k] then
              instance[k] = v
            end
          end
        end
      end
  
      return instance
    end,

    typeof = function(self, Klass)
      return self._class_name == Klass._class_name
    end
  }
  
  setmetatable(ClassDefinition, mt)
  
  return ClassDefinition
end
