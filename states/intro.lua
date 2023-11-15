-- Intro state: Main screen in the game

StateIntro = lazy.extend("StateLevel", State)

local TEXT_START = "START GAME"
local TEXT_CREDITS = "Made by "..META.AUTHOR.." | jadedpuma.com"

local TEXT_TOUCH = "OR TOUCH SCREEN"

local TEXT_VERSION = META.VERSION

function StateIntro:constructor()
    self.starfield_1 = {
        normal = lazy.math.normalAngleDegree(310),
        speed = 0.2,
        pos = lazy.util.position(0, 0)
    }
    self.starfield_2 = {
        normal = lazy.math.normalAngleDegree(310),
        speed = 0.4,
        pos = lazy.util.position(0, 0)
    }

    if DEMO_MODE then
        TEXT_CREDITS = TEXT_CREDITS.." DEMO"
    end

    self.quasar_base_id = 128
    self.quasar_flash_id = 192

    self.quasar_flash_timeout = 150
    self.quasar_flash_time_mod = 5
    self.quasar_flash_toggle = false
    self.quasar_flash_time_max = 25
    self.quasar_flash_time = 0

    -- mouse
    self.mouse_animation = ModAnimate({480, 482}, 40, 2)

    --- timeout to prevent accidental clicking
    self.intro_click_timeout = 15

    self.top = pmem(0)

    music(1)
end

function StateIntro:update(dt)
    if self.intro_click_timeout ~= 0 then
        self.intro_click_timeout = self.intro_click_timeout - 1
    else
        if CURSOR.left then
            STATE_MANAGER:next(TransitionSlide(
                STATE_MANAGER,
                CONFIG.UI.TRANSITION_TIME,
                self,
                StateLevel()
            ))

            music(-1)
        end
    end
end

function StateIntro:render()
    self:_draw_startfield()
    self:_draw_logo()
    self:_draw_credits()
    self:_draw_mouse()

    self:_draw_version()
end

function StateIntro:_draw_startfield()
    -- star field background
    self.starfield_1.pos.x = self.starfield_1.pos.x + self.starfield_1.speed * self.starfield_1.normal.x
    self.starfield_1.pos.y = self.starfield_1.pos.y + self.starfield_1.speed * self.starfield_1.normal.y
    self.starfield_1.pos.x = self.starfield_1.pos.x % SCREEN.WIDTH
    self.starfield_1.pos.y = self.starfield_1.pos.y % SCREEN.HEIGHT
    local x, y = self.starfield_1.pos.x, self.starfield_1.pos.y
    map(30, 0, 30, 17, x, y)
    map(30, 0, 30, 17, x - SCREEN.WIDTH, y)
    map(30, 0, 30, 17, x, y - SCREEN.HEIGHT)
    map(30, 0, 30, 17, x - SCREEN.WIDTH, y - SCREEN.HEIGHT)

    -- Quasar
    local quasar_id = self.quasar_base_id
    if FRAME % self.quasar_flash_timeout  == 0 then
        self.quasar_flash_time = self.quasar_flash_time_max
    end
    if self.quasar_flash_time ~= 0 then
        self.quasar_flash_time = self.quasar_flash_time - 1

        if FRAME % self.quasar_flash_time_mod == 0 then
            self.quasar_flash_toggle = not self.quasar_flash_toggle
        end

        if self.quasar_flash_toggle then
            quasar_id = self.quasar_flash_id
        end
    end
    local x = SCREEN.WIDTH - 32 - 20
    spr(quasar_id, x, 35, 0, 1, 0, 0, 4, 4)

    self.starfield_2.pos.x = self.starfield_2.pos.x + self.starfield_2.speed * self.starfield_2.normal.x
    self.starfield_2.pos.y = self.starfield_2.pos.y + self.starfield_2.speed * self.starfield_2.normal.y
    self.starfield_2.pos.x = self.starfield_2.pos.x % SCREEN.WIDTH
    self.starfield_2.pos.y = self.starfield_2.pos.y % SCREEN.HEIGHT
    local x, y = self.starfield_2.pos.x, self.starfield_2.pos.y
    map(60, 0, 30, 17, x, y, 0)
    map(60, 0, 30, 17, x - SCREEN.WIDTH, y, 0)
    map(60, 0, 30, 17, x, y - SCREEN.HEIGHT, 0)
    map(60, 0, 30, 17, x - SCREEN.WIDTH, y - SCREEN.HEIGHT, 0)
end

function StateIntro:_draw_logo()
    local x = SCREEN.WIDTH / 2 - 32 - 16
    local y = SCREEN.HEIGHT / 2 - 32 - 16

    spr(132, x, y, 0, 1, 0, 0, 8, 8)
    spr(140, x + 64, y, 0, 1, 0, 0, 4, 4)
    spr(204, x + 64, y + 32, 0, 1, 0, 0, 4, 4)
end

function StateIntro:_draw_credits()
    local color = 5
    local colorbg = 2

    local x = 1
    local y = SCREEN.HEIGHT -  8 * 2

    print(TEXT_CREDITS, x+1 , y+1 + 8, colorbg)
    print(TEXT_CREDITS, x , y + 8, color)
end

function StateIntro:_draw_mouse()
    local x = 1
    local y = 1

    self.mouse_animation:render(FRAME, x, y)

    local color = 15
    local colorbg = 2
    local color_faint = 5

    y = y + 2
    x = x + 17
    print(TEXT_START, x+1 ,y+1, colorbg)
    print(TEXT_START, x ,y, color)
    x = x + 5*12
    local top = "- HSCORE "..self.top
    print(top, x+1 ,y+1, colorbg)
    print(top, x ,y, color)

    x = 18
    y = y + 8
    print(TEXT_TOUCH, x ,y, color_faint)

end

function StateIntro:_draw_version() 
    -- TEXT_VERSION
    local width = print(TEXT_VERSION, -100, -100, 0)

    print(TEXT_VERSION, SCREEN.WIDTH - width, 3, 2)

end