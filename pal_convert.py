import math
import re

pal_string = "0000002020263a363dab37375052736e66609e489157946059909ee0864af56c7796d45bbab1976be0bff5d678f9fff2"

h_mod = 0
s_mod = -0.10
v_mod = -0.05

def main():
    pal = re.findall(r"......", pal_string)

    new_pal = ""

    for hex_color_string in pal:
        hex_color = int(hex_color_string, 16)


        r = (hex_color & 0xFF0000) >> 16
        g = (hex_color & 0x00FF00) >> 8
        b = (hex_color & 0x0000FF)
        #print(f"rgb: {r}|{g}|{b}")

        h, s, v = rgb_to_hsv(r, g, b)
        print(f"HSV: {hex_color_string}:{hex_color:x} ", h, s, v)

        h += h_mod
        s += s_mod
        v += v_mod

        h = min(max(h, 0), 360)
        s = min(max(s, 0), 100)
        v = min(max(v, 0), 100)

        r, g, b = hsv_to_rgb(h, s, v)

        color = f"{r:02x}{g:02x}{b:02x}"

        new_pal += color

        print(f"old[{hex_color_string}] new[{color}]")

    print(f"new pal: {new_pal}")



def rgb_to_hsv(r, g, b):
    # R, G and B input range = 0 ÷ 255
    # H, S and V output range = 0 ÷ 1.0

    var_R = ( r / 255 )
    var_G = ( g / 255 )
    var_B = ( b / 255 )

    var_Min = min(var_R, var_G, var_B)
    var_Max = max(var_R, var_G, var_B)
    del_Max = var_Max - var_Min

    h, s = 0, 0
    v = var_Max

    if del_Max == 0:
        h = 0
        s = 0
    else:
        s = del_Max / var_Max

        del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
        del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
        del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max

        if var_R == var_Max: h = del_B - del_G
        elif var_G == var_Max: h = ( 1 / 3 ) + del_R - del_B
        elif var_B == var_Max: h = ( 2 / 3 ) + del_G - del_R

        if h < 0: h += 1
        if h > 1: h -= 1
    return h, s, v


def hsv_to_rgb(h, s, v):
    # H, S and V input range = 0 ÷ 1.0
    # R, G and B output range = 0 ÷ 255

    r, g, b = 0, 0, 0

    if s == 0:
        r = v * 255
        g = v * 255
        b = v * 255
    else:
        var_h = h * 6
        if var_h == 6: var_h = 0      # H must be < 1

        var_i = math.floor( var_h )
        var_1 = v * (1 - s)
        var_2 = v * (1 - s * (var_h - var_i))
        var_3 = v * (1 - s * (1 - (var_h - var_i )))


        if var_i == 0:
            var_r = v
            var_g = var_3 
            var_b = var_1
        elif var_i == 1: 
            var_r = var_2
            var_g = v
            var_b = var_1
        elif var_i == 2:
            var_r = var_1
            var_g = v 
            var_b = var_3
        elif var_i == 3:
            var_r = var_1
            var_g = var_2
            var_b = v
        elif var_i == 4: 
            var_r = var_3 
            var_g = var_1 
            var_b = v
        else:
            var_r = v
            var_g = var_1
            var_b = var_2

        r = var_r * 255
        g = var_g * 255
        b = var_b * 255

    return int(r), int(g), int(b)



if __name__ == '__main__':
	print("CREATING PAL...")
	main()
	print("DONE")