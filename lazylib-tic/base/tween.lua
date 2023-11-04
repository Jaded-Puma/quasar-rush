-- Tween functions API

local tween = {}
lazy.tween = tween

tween.func = {}



-- exp tweens
tween.func.easeInExp = function (x, n)
    return x^n
end

tween.func.easeOutExp = function(x, n)
    return 1 - (1 - x)^n
end

-- tween fucntions
tween.func.linear = function(x)
    return x
end

tween.func.easeOutQuart = function (x)
    return 1 - (1 - x)^4
end

tween.func.easeInQuart = function(x)
    return x * x * x * x;
end

local c1 = 1.70158;
local c3 = c1 + 1;
tween.func.easeOutBack = function(x)
    return 1 + c3 * (x - 1)^3 + c1 * (x - 1)^2
end

tween.func.easeInBack = function(x)
    return c3 * x * x * x - c1 * x * x
end

tween.func.easeOutCubic = function(x)
    return 1 - (1 - x)^3
end

