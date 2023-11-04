EnemyBaseLogic = lazy.class("EnemyBaseLogic")

function EnemyBaseLogic:constructor() 

end

function EnemyBaseLogic:update(dt) end

function EnemyBaseLogic:kill()
    self.entity.delete = true
    self.entity.game_logic:particle_explosion(self.entity.x + self.entity.w / 2, self.entity.y + self.entity.h / 2)
    self.entity.game_logic.sfx_handler:add(SfxEntity(self.entity.x, self.entity.y, DATA.GFX.EXPLOSION))

    DATA.SFX[DATA.SFX.INDEX.EXPLODE]:play()
    DATA.CAMERA.ENEMY_EXPLOSION:shake(self.entity.game_logic.camera)
end

--- ! deprecated
function EnemyBaseLogic:drop_item()
    local type_i = UTILITY.get_weighted_value(CONFIG.GLOBAL.DROP_RATE_BASE)
    if self.use_alt_pal then
        type_i = UTILITY.get_weighted_value(CONFIG.GLOBAL.DROP_RATE_CORRUPT)
    end

    local exp_entity = ExpEnitity(
        type_i,
        self.entity.x + 8 - 4, self.entity.y + 8 - 4
    )

    self.entity.game_logic.exp_handler:add(exp_entity)

    return exp_entity
end

function EnemyBaseLogic:is_immune()
    return self.hp_mod < 0
end