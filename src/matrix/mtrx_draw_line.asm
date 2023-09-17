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
; Public routine - This routine validate inputs and
;   then sets pixels to draw a line.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_draw_line
;
; Set pixels in the display buffer to draw a line from 
; the origin x0, y0 to endpoint x1, y1.
;
; Parameters: 
;   r7.1 - origin y 
;   r7.0 - origin x 
;   r8.1 - endpoint y 
;   r8.0 - endpoint x 
;
; Note: Checks x,y values, error if out of bounds
;                  
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_draw_line

            call    gfx_check_bounds
            lbdf    dl_exit
 
                         
dl_chk:     push    r7        ; save origin value
            copy    r8, r7    ; copy endpoint for bounds check
            call    gfx_check_bounds
            pop     r7        ; restore origin x,y
            lbdf    dl_exit   ; if out of bounds return error

            push    r9        ; save registers used in gfx_write_line
            push    r8
            push    r7
                      
            call    gfx_write_line
            pop     r7        ; restore registers
            pop     r8
            pop     r9

dl_exit:    return
            
            endp
