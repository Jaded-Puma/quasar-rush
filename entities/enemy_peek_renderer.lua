EnemyPeekRenderer = lazy.class("EnemyPeekRenderer")

function EnemyPeekRenderer:constructor(entity)
    self.entity = entity

    self.tile = 2
    self.main_spr_id = 328
    self.part_spr_id = 360

    self.main_spr_id_alt = 424
    self.part_spr_id_alt = 456
end

function EnemyPeekRenderer:render()
    local camera = self.entity.game_logic.camera

    local pal = UTILITY.get_pal(self.entity)

    local main_id = self.main_spr_id
    local part_id = self.part_spr_id
    if self.entity.logic.use_alt_pal then
        main_id = self.main_spr_id_alt
        part_id = self.part_spr_id_alt
    end

    lazy.tic.set_palette_from_table(pal)
    self.entity.logic.flashing:render_function(
        function()
            spr(
                main_id,
                self.entity.x + camera.xs, self.entity.y + camera.ys,
                0, 1, 0, 0,
                self.tile, self.tile
            )

            local parts_count = math.ceil((self.entity.logic.peek_amount - 16) / 16)

            for i = 1, parts_count do
            spr(
                part_id,
                self.entity.x + camera.xs, self.entity.y + camera.ys + i * 16,
                    0, 1, 0, 0,
                self.tile, self.tile
            )
            end
        end
    )
    lazy.tic.palette_reset()
end