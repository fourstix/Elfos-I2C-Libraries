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
; Name: mtrx_print_char
;
; Print a single character to the display. 
;
; Parameters: 
;   r9.1 - color
;   r9.0 - ASCII character to draw 
;
; Registers Used:
;   r7.1 - origin y 
;   r7.0 - origin x 
;   r8   - scratch register
;
; Note: Checks to see if any possible overlap with the
;   display before drawing bitmap.
;                  
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_print_char
                                          
            push    r9                ; save registers used
            push    r8
            push    r7
            
            call    mtrx_clear        ; clear out display buffer

            ldi     1                 ; set orign to 1,0
            plo     r7                ; set x origin
            ldi     0
            phi     r7                ; set y origin
            
            call    gfx_write_char
            
            pop     r7                ; restore registers        
            pop     r8
            pop     r9

dc_exit:    return

            endp
