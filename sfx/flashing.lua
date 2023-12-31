-- Implements flashing animation to work with the rendering logic of tic-80
-- This class acts more like an psudo-interface

Flashing = lazy.class("Flashing")

function Flashing:constructor()
    self.time = 0
    self.cooldown = 0
end

function Flashing:update(dt)
    if self.time ~= 0 then
        self.time = self.time - 1
    end

    if self.time == 0 and self.cooldown ~= 0 then
        self.cooldown = self.cooldown - 1
    end
end

function Flashing:render_function(func)

    if self.time ~= 0 then
        lazy.tic.set_palette_from_table(CONFIG.GLOBAL.FLASH_PALATTE)
        func()
        lazy.tic.palette_reset()
    else
        func()
    end

end

function Flashing:start(time)
    if self.cooldown ~= 0 then
        return
    end

    self.time = time and time or CONFIG.GLOBAL.FLASH_TIME
    self.cooldown = 2
end

function Flashing:is_flashing()
    return self.time ~= 0
end