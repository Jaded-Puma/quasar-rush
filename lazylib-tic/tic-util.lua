-- Utility library for TIC-80 API

local tic = {}
lazy.tic = tic

tic._default_palette = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
tic._palette = default_palette
tic._palette_map = 0x3FF0
tic._color_bit = 4

tic._channel_prio = {-1, -1, -1, -1}

function tic.rspr(sx, sy, scale, angle, mx, my, mw, mh, key, useMap)
    angle = -rad(angle)

    --  this is fixed , to make a textured quad
    --  X , Y , U , V
    local sv = { { -1, -1, 0, 0 },
        { 1, -1, 0.999, 0 },
        { -1, 1, 0, 0.999 },
        { 1, 1, 0.999, 0.999 } }

    -- local rp = {} --  rotated points storage

    --  the scale is mw ( map width ) * 4 * scale
    --  mapwidth is * 4 because we actually want HALF width to center the image
    local scalex = (mw << 2) * scale
    local scaley = (mh << 2) * scale

    --  rotate the quad points
    for p = 1, #sv do
        -- apply scale
        local _sx = sv[p][1] * scalex
        local _sy = sv[p][2] * scaley
        -- apply rotation
        local a = -angle
        local rx = _sx * math.cos(a) - _sy * math.sin(a)
        local ry = _sx * math.sin(a) + _sy * math.cos(a)
        -- apply transform
        sv[p][1] = rx + sx
        sv[p][2] = ry + sy
        -- scale UV's
        sv[p][3] = (mx << 3) + (sv[p][3] * (mw << 3))
        sv[p][4] = (my << 3) + (sv[p][4] * (mh << 3))
    end
    -- draw two triangles for the quad
    textri(sv[1][1], sv[1][2],
        sv[2][1], sv[2][2],
        sv[3][1], sv[3][2],
        sv[1][3], sv[1][4],
        sv[2][3], sv[2][4],
        sv[3][3], sv[3][4],
        useMap, key)

    textri(sv[2][1], sv[2][2],
        sv[3][1], sv[3][2],
        sv[4][1], sv[4][2],
        sv[2][3], sv[2][4],
        sv[3][3], sv[3][4],
        sv[4][3], sv[4][4],
        useMap, key)
end

tic.border_color = function(color)
    poke(0x03FF8, color)
end

tic.replace_color = function(color1, color2)
    poke4(tic._palette_map * 2 + color1, color2)
end

tic.palette_reset = function()
    for i = 0, 15 do
        poke4(tic._palette_map * 2 + i, i)
    end

    tic._palette = tic._default_palette
end

tic.set_palette_from_table = function(palette_table)
    palette_table = palette_table and palette_table or tic._palette

    for i = 0, #palette_table - 1 do
        tic.replace_color(i, palette_table[i + 1])
    end

    tic._palette = palette_table
end

tic.spr_textri = function(id, sw, sh, x1, y1, x2, y2, x3, y3, x4, y4, color_key)
    color_key = color_key and color_key or 0
    sw = sw * 8
    sh = sh * 8

    local uvx = (id % 16) * 8
    local uvy = (id // 16) * 8

    local t1u1 = uvx
    local t1v1 = uvy
    local t1u2 = uvx + sw
    local t1v2 = uvy
    local t1u3 = uvx
    local t1v3 = uvy + sh

    local t2u1 = uvx + sw
    local t2v1 = uvy
    local t2u2 = uvx
    local t2v2 = uvy + sh
    local t2u3 = uvx + sw
    local t2v3 = uvy + sh

    --t1
    textri(
        --screen
        x1, y1,
        x2, y2,
        x3, y3,
        --uv map
        t1u1, t1v1,
        t1u2, t1v2,
        t1u3, t1v3,
        --use map
        false,
        --trans
        color_key)

    --t2
    textri(
        --screen
        x2, y2,
        x3, y3,
        x4, y4,
        --uv map
        t2u1, t2v1,
        t2u2, t2v2,
        t2u3, t2v3,
        --use map
        false,
        --trans
        color_key)
end

tic.spr_dist = function(id, sw, sh, x, y, w, h, colkey)
    colkey = colkey and colkey or 0
    sw = sw * 8
    sh = sh * 8

    local uvx = (id % 16) * 8
    local uvy = (id // 16) * 8

    --tri1
    local t1x1 = x
    local t1y1 = y
    local t1x2 = x
    local t1y2 = y + h
    local t1x3 = x + w
    local t1y3 = y

    local t1u1 = uvx
    local t1v1 = uvy
    local t1u2 = uvx
    local t1v2 = uvy + sh
    local t1u3 = uvx + sw
    local t1v3 = uvy

    --tri2
    local t2x1 = x
    local t2y1 = y + h
    local t2x2 = x + w
    local t2y2 = y
    local t2x3 = x + w
    local t2y3 = y + h

    local t2u1 = uvx
    local t2v1 = uvy + sh
    local t2u2 = uvx + sw
    local t2v2 = uvy
    local t2u3 = uvx + sw
    local t2v3 = uvy + sh

    --t1
    textri(
    --screen
        t1x1, t1y1,
        t1x2, t1y2,
        t1x3, t1y3,
        --uv map
        t1u1, t1v1,
        t1u2, t1v2,
        t1u3, t1v3,
        --use map
        false,
        --trans
        colkey)

    --t2
    textri(
    --screen
        t2x1, t2y1,
        t2x2, t2y2,
        t2x3, t2y3,
        --uv map
        t2u1, t2v1,
        t2u2, t2v2,
        t2u3, t2v3,
        --use map
        false,
        --trans
        colkey)
end

tic.draw_box_class = function(box, color, bb_key)
    if bb_key then
        local bb = box:getBoundingBox(bb_key)
        rectb(box.x + bb.x, box.y + bb.y, bb.w, bb.h, color)
    else
        rectb(box.x, box.y, box.w, box.h, color)
    end
    
end

tic.get_channel_data = function(channel)
    local value = peek(0xFF9C+18*channel+1)<<8|peek(0xFF9C+18*channel)
    local frequency = (value&0x0fff)
    local volume = (value&0xf000)>>12

    return frequency, volume
end

tic.set_channel_prio = function(channel, prio)
    tic._channel_prio[channel] = prio
end

tic.get_channel_prio = function (channel)
    return tic._channel_prio[channel]
end