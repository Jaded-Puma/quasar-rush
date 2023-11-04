-- Extend functionality for lazylib Class implementation

lazy.extend = function(class_name, FromClass)

  local NewClass = lazy.class(class_name)

  for k,v in pairs(FromClass) do
    if k ~= "constructor" 
    and k ~= "_instantiate" 
    and k ~= "initialize" 
    and k ~= "_class_name" then
      NewClass[k] = v
    end
  end
  
  NewClass.super = FromClass
  
  return NewClass
end
