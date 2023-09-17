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
; Name: gfx_check_bounds
;
; Check to see if signed byte values for a point x,y 
; are inside of the display boundaries.
;
; Parameters: 
;   r7.1 - y (display line, 0 to 7)
;   r7.0 - x (pixel offset, 0 to 7)
;
; Note: Values x and y are signed byte values
;             
; Return: DF = 1 if error
;              ie x > 7 or x < 0 or y > 7 or y < 0 
;         DF = 0 if no error
;              ie 0 <= x <= 7 and 0 <= y <= 7
;-------------------------------------------------------
            proc    gfx_check_bounds
            ghi     r7                ; check y value
            smi     DISP_HEIGHT       ; anything over 7 is an error
            lbdf    xy_done           ; if out of bounds, exit immediately
            
            glo     r7                ; check x value
            smi     DISP_WIDTH        ; anything over 7 is an error
xy_done:    return

            endp
