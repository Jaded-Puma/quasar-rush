ExpEnitity = lazy.extend("ExpEnitity", Entity)

local DEL_BUFFER = 8

function ExpEnitity:constructor(type, x, y)

    self.STATES = lazy.enum("FALL", "IN")
    self.state = self.STATES.FALL

    self.in_speed = 1.5
    self.in_entity = nil

    self.speed = 1

    self.animate_exp   = ModAnimate({302, 303, 318, 319}, 7)
    self.animate_level = ModAnimate({300, 301, 316, 317}, 7)
    self.animate_heart = ModAnimate({296, 296, 296, 296, 296, 297, 298, 312, 313, 314}, 5)

    self.type = type
    if self.type == CONFIG.GLOBAL.DROP_TYPE.EXP then
        self.animate = self.animate_exp
    elseif self.type == CONFIG.GLOBAL.DROP_TYPE.LEVEL then
        self.animate = self.animate_level
    elseif self.type == CONFIG.GLOBAL.DROP_TYPE.HEART then
        self.animate = self.animate_heart
    else
        self.animate = ModAnimate({1, 1}, 7)
    end

    ExpEnitity.super:initialize(
        self,
        x, y,
        8, 8
    )
end

function ExpEnitity:update(dt)

    if self.state == self.STATES.FALL then
        self.y = self.y + self.speed
    elseif self.state == self.STATES.IN then
        -- get change
        local dx = self.in_entity.x + 4 - self.x
        local dy = self.in_entity.y + 4 - self.y
        -- get normalized vector
        local l = math.sqrt(dx^2 + dy^2)
        local normal_x = dx / l
        local normal_y = dy / l
        -- apply speed
        local pos_x = self.in_speed * normal_x
        local pos_y = self.in_speed * normal_y
        -- apply position
        self.x = self.x + pos_x
        self.y = self.y + pos_y

        -- check for object destruction
        if lazy.util.is_box_inside_box(self.x+3, self.y+3, self.w-6, self.h-6, 
        self.in_entity.x+5, self.in_entity.y+5, self.in_entity.w-10, self.in_entity.h-10) then
            self.delete = true

            

            if self.type == CONFIG.GLOBAL.DROP_TYPE.EXP then
                self.in_entity.logic:addExp()
                DATA.SFX[DATA.SFX.INDEX.EXP_COLLECT]:play()
            elseif self.type == CONFIG.GLOBAL.DROP_TYPE.LEVEL then
                self.in_entity.logic:addLevel()
            elseif self.type == CONFIG.GLOBAL.DROP_TYPE.HEART then
                self.in_entity.logic:addHealth()
                DATA.SFX[DATA.SFX.INDEX.HEALTH_UP]:play()
            end
        end
    end

    if self.y > CONFIG.GAME.VIEWPORT.H + DEL_BUFFER then
        self.delete = true
    end
end

function ExpEnitity:render()
    self.animate:render(FRAME, self.x, self.y)
end

-- TODO: replace with game_logic ref
function ExpEnitity:setInEntity(entity)
    self.in_entity = entity
end