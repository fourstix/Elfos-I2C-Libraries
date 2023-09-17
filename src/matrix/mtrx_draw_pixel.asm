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
;   then sets a single pixel.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_draw_pixel
;
; Set a pixel in the display buffer at position x,y.
;
; Parameters: r7.1 - y (line, 0 to 7)
;             r7.0 - x (pixel offset, 0 to 7)
;             r9.1 = color  
;
; Note: Checks x,y values, returns error if out of bounds
;                  
; Return: DF = 1 if error, 0 if no error
; 
;-------------------------------------------------------
            proc   mtrx_draw_pixel
            
            call   gfx_check_bounds
            lbdf   dp_exit    ; exit immediately if out of bounds

            call   gfx_write_pixel  
dp_exit:    return
            
            endp
