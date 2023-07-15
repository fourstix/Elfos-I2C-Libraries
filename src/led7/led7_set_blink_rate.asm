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

;-------------------------------------------------------------------------------
; Routines used by library routines
;-------------------------------------------------------------------------------

            extrn   i2c_wrbuf
            extrn   led7_clear
            extrn   led7_write_disp
            extrn   led7_digits
            extrn   led7_display_buf
            extrn   led7_cmd_buf

;-------------------------------------------------------------------------------
; This routine turns off the blink rate for the display
;-------------------------------------------------------------------------------
; Parameters:
;   RB.0 - blink rate
; Registers Used:
;   RD   - pointer to the display buffer
;-------------------------------------------------------------------------------
            proc    led7_set_blink_rate

            push    rd
            
            mov     rd, led7_cmd_buf
            glo     rb
            shl
            ani     06h
            ori     CMD_BLINK | DISP_ON
            str     rd
            call    i2c_wrbuf
            db      I2C_ADDR, 1
            dw      led7_cmd_buf

            pop     rd
            return

            endp
