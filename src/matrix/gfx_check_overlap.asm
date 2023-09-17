;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit LED matrix
; display with I2C running from an 1802-Mini Computer with the PIO and 
; I2C Expansion Boards.
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2022 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Based on code from Adafruit_GFX library
; Written by Limor Fried/Ladyada for Adafruit Industries  
; Copyright 2012 by Adafruit Industries
;
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------
#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/ht16k33_def.inc  
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------
; Private routine - called only by the public routines
; These routines may *not* validate or clip. They may 
; also consume register values passed to them.
;-------------------------------------------------------
;-------------------------------------------------------
; Name: gfx_check_overlap
;
; Check to see if an 8x8 bitmap at origin x,y 
; overlaps the canvas
;
; Parameters: 
;   r7.1 - y origin (upper left corner)
;   r7.0 - x origin (upper left corner)
;   r8.1 - h bitmap height
;   r8.0 - w bitmap width
;
; Note: Values x and y are signed byte values. In 
;   the logic below negative values are treated like
;   large positive numbers and subtraction yields an
;   absolute value.
;             
; Return: DF = 1 if outside (nothing to draw)
;         DF = 0 if inside (bitmap overlaps canvas)
;-------------------------------------------------------
            proc    gfx_check_overlap
            ; check left corners first
            glo     r7                ; check x value
            smi     DISP_WIDTH        ; any absolute value over 7 is outside
            lbdf    chk_right         ; if x0 out of range, check right corners
            
            ; check upper left corner
            ghi     r7                ; check y value at upper left corner
            smi     DISP_HEIGHT       ; any absolute value under 8 is inside
            lbnf    xy_in             ; if in bounds, exit with DF = 0
            
            ; check lower left corner
            ghi     r7                ; check y value at lower left corner
            str     r2                ; save y0 in M(X)
            ghi     r8                ; get bitmap height
            add                       ; y = y0 + h (signed addition)
            smi     DISP_HEIGHT       ; any absolute value under 8 is inside
            lbnf    xy_in             ; if in bounds, exit with DF = 0
            
chk_right:  glo     r7                ; check right corners
            str     r2                ; save x0 in M(X)
            glo     r8                ; get bitmap width
            add                       ; x = x0 + 8 (signed addition)               
            smi     DISP_WIDTH        ; any absolute value over 7 is outside
            lbdf    xy_out            ; if outside, exit with DF = 1
            
            ; check upper right corner
            ghi     r7                ; check y value at upper right corner
            smi     DISP_HEIGHT       ; any absolute value under 8 is inside
            lbnf    xy_in             ; if in bounds, exit with DF = 0
            
            ; check lower right corner
            ghi     r7                ; check y value at lower left corner
            str     r2                ; save y0 in M(X)
            ghi     r8                ; get bitmap height
            add                       ; y = y0 + h (signed addition)
            smi     DISP_HEIGHT       ; any absolute value under 8 is inside
            lbnf    xy_in             ; if in bounds, exit with DF = 0
            

xy_out:     stc                       ; DF = 1 (nothing to draw)
            return

xy_in:      clc                       ; DF = 0 (draw bitmap)
            return
            endp
