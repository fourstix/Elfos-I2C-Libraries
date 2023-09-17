
            extrn   twist_avail
            extrn   twist_get_version
            extrn   twist_get_status
            extrn   twist_get_count
            extrn   twist_set_count
            extrn   twist_get_diff
            extrn   twist_last_move
            extrn   twist_last_press
            extrn   twist_set_color
            extrn   twist_get_color
            extrn   twist_chg_red
            extrn   twist_chg_green
            extrn   twist_chg_blue

;-------------------------------------------------------------------------------
; Status bit values for Sparkfun Twist RGB Rotary Encoder
;-------------------------------------------------------------------------------

TWIST_MOVED:          equ $01   ; encoder moved since last read
TWIST_DOWN:           equ $02   ; button currently down
TWIST_PRESSED:        equ $04   ; button previously down since last read
