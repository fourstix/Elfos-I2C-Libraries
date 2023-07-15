;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit 4 digit 7-segment
; display with I2C running from an 1802-Mini Computer with the PIO and 
; I2C Expansion Boards. These routines are meant to be called using SCRT 
; in Elf/OS with X=R2 being the stack pointer.
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
; Adafruit 4 Digit 7-Segment Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/ht16k33_def.inc
#include    ../include/led7_lib.inc  
#include    ../include/i2c_lib.inc  

;-------------------------------------------------------------------------------
; This routine clears the display buffer
;-------------------------------------------------------------------------------
; Registers Used:
;   RD   - pointer to the display buffer
;   R9.0 - byte counter
;-------------------------------------------------------------------------------

            proc    led7_clear

            push    rd
            push    r9
            
            mov     rd, led7_display_buf+1
            ldi     16
            plo     r9

clr_loop:   ldi     0
            str     rd
            inc     rd
            dec     r9
            glo     r9
            lbnz    clr_loop

            pop     r9
            pop     rd      
            return

            endp
