;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit 4 LED matrix
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
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------------------------------
; This routine clears the matrix display buffer
; Registers Used:
;   RD   - pointer to the display buffer
;   RA.0 - byte counter
;-------------------------------------------------------------------------------

            proc    mtrx_clear

            push    rd
            push    ra

            ; one display byte + 8 lines of 2 bytes 
            ; each pixel has 2 bytes (one green byte + one red byte)
            
            load    rd, mtrx_buffer
            ldi     17                   
            plo     ra

clr_loop:   ldi     0
            str     rd
            inc     rd
            dec     ra
            glo     ra
            lbnz    clr_loop

            pop     ra
            pop     rd
            clc      
            return

            endp
