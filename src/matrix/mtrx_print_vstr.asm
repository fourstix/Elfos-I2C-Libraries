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
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------
; Public routine - This routine validates the origin
;   and clips the bitmap to the edges of the display.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_print_vstr
;
; Print a string vertically on the display as 
; upward scrolling 8x8 characters. 
;
; Parameters: 
;   r9.1 - color
;   rf - pointer to string buffer 
;
; Registers Used:
;   rd.1 - previous character to print
;   rd.0 - next character to print
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_print_vstr
                                          
            push    rd                ; save registers used
            
            ldi     ' '               ; put space as previous character
            phi     rd
            
pl_loop:    lda     rf
            lbz     pl_finish
              
            plo     rd                ; put next character to print

            call    mtrx_scroll_up
            lbdf    pl_exit           ; exit immediately, if error
          
            glo     rd                ; move old character from next
            phi     rd                ; into previous

            lbr     pl_loop           ; keep going for entire string
            
pl_finish:  ldi     ' '               ; scroll out last character
            plo     rd
            
            call    mtrx_scroll_up
            lbdf    pl_exit           ; exit immediately, if error
            
pl_exit:    pop     rd                ; restore registers        
            return

            endp
