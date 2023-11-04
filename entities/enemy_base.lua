EnemyBase = lazy.extend("EnemyBase", Entity)

function EnemyBase:constructor(game_logic, config, x, y, w, h)
    self.game_logic = game_logic
    self.config = config

    self.render_prio = 0

    self.spawn_group = {}

    EnemyBase.super:initialize(
        self,
        x, y,
        w, h
    )
end

function EnemyBase:spawn() end

function EnemyBase:setup_hardmode(logic)
    if logic.entity.game_logic.hard_mode then
        local hp_cor_inc = logic.use_alt_pal and CONFIG.HARDMODE.HP_COR_INC or 0

        logic.pal_mode = CONFIG.HARDMODE.PAL
        logic.hp = logic.hp + CONFIG.HARDMODE.HP_INCREASE + hp_cor_inc
        logic.hp = lazy.math.round(logic.hp * (1 + CONFIG.HARDMODE.HP_MUL))
    end
end