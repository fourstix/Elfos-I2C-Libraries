;-------------------------------------------------------------------------------
; keypad_avail - a routine to check the i2c bus for the presence of a 
; Sparkfun Qwiic 12 Button Keypad with I2C using the PIO and I2C Expansion
; Boards for the 1802/Mini Computer.
;
; Copyright 2023 by Gaston Williams
;
; Based on the the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Sparkfun Qwiic 12 Button Keypad hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15290 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/keypad_def.inc

;-------------------------------------------------------------------------------
; This routine checks the i2c bus for the presence of a keypad
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    keypad_avail
            
            call    i2c_avail          ; i2c address = $4B
            db      I2C_ADDR

            return
            endp
