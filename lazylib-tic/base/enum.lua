-- add a Enum "class" to lua.

lazy._enumdata = {}

lazy.enum = function(...)
  local reverse_ref = {}
  local ref = { ... }

  local enum = {}

  for i, v in ipairs(ref) do
    reverse_ref[i] = v
    enum[v] = i
  end

  lazy._enumdata[enum] = {
    _reverse_ref = reverse_ref,
    _ref = ref
  }

  enum.getEnum = function (self, index)
    return lazy._enumdata[self]._reverse_ref[index]
  end

  return enum
end
