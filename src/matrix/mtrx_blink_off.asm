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
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------------------------------
; This routine turns off the blink rate for the display
;-------------------------------------------------------------------------------
; Returns:
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    mtrx_blink_off
            
            call    i2c_wrbuf
            db      I2C_ADDR, 1
            dw      b_off_cmd
            
            return
            
b_off_cmd:  db  CMD_BLINK | DISP_ON       ; BLINK_OFF is zero
            endp
