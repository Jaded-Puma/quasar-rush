-- Debug API

local debug = {}
lazy.debug = debug

debug.table_tostring = function(o, get_level)
  local level = get_level
  if level == nil then
    level = 0
  end

  local pad1 = ""
  local pad2 = "  "

  if level ~= 0 then
    for i = 1, level do
      pad1 = pad1 .. "  "
      pad2 = pad2 .. "  "
    end
  end

  if type(o) == "table" then
    local s = '{\n'

    for k, v in pairs(o) do
      if type(k) ~= "number" then k = "'" .. k .. "'" end
      s = pad2 .. s .. "[" .. k .. "] = " .. lazy.debug.table_tostring(v, level + 1) .. "\n"
    end

    return pad1 .. s .. "\n}\n"
  else
    return pad2 .. tostring(o)
  end
end

debug.print = function(text, ...)
  lazy.log(text .. debug.table_tostring({ ... }))
end