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
;   and clips the bitmap to the edges of the display.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_draw_bitmap
;
; Set pixels in the display buffer to draw an 8x8 bitmap 
; with its upper left corner at the position x,y.
;
; Bitmap size must be 8x8. Other sizes are not supported.
;  
; Pixels corresponding to 1 values in the bitmap data 
; are set.  Pixels corresponding to 0 values in the 
; bitmap data are unchanged.
;
; Parameters: 
;   r7.1 - origin y (signed value)
;   r7.0 - origin x (signed value) 
;   r8.1 - h bitmap height
;   r8.0 - w bitmap width
;   r9.1 - color
;   rf   - pointer to 8x8 bitmap (eight data bytes)
;
; Note: Checks to see if any possible overlap with the
;   display before drawing bitmap.
;                  
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_draw_bitmap

            call    gfx_check_overlap
            lbnf    dbmp_ok           ; if overlap, continue
            clc                       ; otherwise clear error
            return                    ; and return
            
dbmp_ok:    push    rf                ; save registers used
            push    r9                
            push    r7
                       
            call    gfx_write_bitmap  ; draw new bitmap

db_err:     pop     r7                ; restore registers        
            pop     r9
            pop     rf        

db_exit:    return
            endp
