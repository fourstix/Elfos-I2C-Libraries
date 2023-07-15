;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun 4 character 14-Segment
; Alphanumeric display with I2C running from an 1802-Mini Computer with the PIO
; and I2C Expansion Boards. These routines are meant to be called using SCRT 
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
; Sparkfun 4 Character 14-Segment Alphanumeric Display hardware
; Copyright 2019-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/categories/820 for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/ht16k33_def.inc
#include    ../include/alnum_lib.inc
#include    ../include/i2c_lib.inc


;-------------------------------------------------------------------------------
; This routine sets the blink rate for the display
;-------------------------------------------------------------------------------
; Parameters:
;   RB.0 - blink rate
; Registers Used:
;   RD   - pointer to the display buffer
; Returns: 
;     DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    alnum_set_blink_rate

            push    rd
            
            mov     rd, alnum_cmd_buf
            glo     rb
            shl
            ani     06h
            ori     CMD_BLINK | DISP_ON
            str     rd
            call    i2c_wrbuf
            db      I2C_ADDR, 1
            dw      alnum_cmd_buf

            pop     rd
            rtn

            endp
