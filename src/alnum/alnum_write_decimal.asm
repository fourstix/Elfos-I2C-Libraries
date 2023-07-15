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

#define     AL_DECIMAL_OFFSET     4

;-------------------------------------------------------------------------------
; This routine sets the colon value in the display buffer
;-------------------------------------------------------------------------------
; Parameters:
;   (None)
; Registers Used:
;   RD   - pointer to the display buffer
;-------------------------------------------------------------------------------

            proc    alnum_write_decimal

            push    rd                ; save register
            
            LOAD    rd, alnum_display_buf + AL_DECIMAL_OFFSET
            ldn     rd                ; get decimal byte from display buffer
            ori     01h               ; set decimal bit on
            str     rd                ; save updated byte in display buffer

            pop     rd                ; restore register
            return

            endp
