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
; Public routine - This routine validates the origin
;   and clips the rectangle to the display edges.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_draw_rect
;
; Set pixels in the display buffer to create a 
; rectangle with its upper left corner at position x,y
; and sides of width w and height h.
;
; Parameters: 
;   r9.1 - color
;   r8.1 - h 
;   r8.0 - w 
;   r7.1 - origin y 
;   r7.0 - origin x 
;
; Note: Checks origin x,y values, error if out of bounds
; and the w, h values may be clipped to edge of display.
;                  
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_draw_rect
            call    gfx_check_bounds
            lbdf    dr_skip           ; if out of bounds, don't draw
            
            push    r9                ; save registers used
            push    r8
            push    r7
            call    gfx_adj_bounds    ; adjust w and h, clip if needed
            lbdf    dr_exit           ; if error, exit immediately
            
            call    gfx_write_rect    ; draw rectangle
                    
dr_exit:    pop     r7                ; restore registers        
            pop     r8
            pop     r9
dr_skip:    return
            endp
