;-------------------------------------------------------------------------------
; keypad_update - a routine to update the key value register with a key
; press from the FIFO buffer on a Sparkfun Qwiic 12 Button Keypad with
; I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
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
; Sparkfun Qwiic 12 Button Keypad hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15290 for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/i2c_lib.inc
#include    ../include/util_lib.inc
#include    ../include/keypad_def.inc

;-------------------------------------------------------------------------------
; This routine updates the key value register with a key press from 
; the keypad fifo stack so that a key value can be read with I2C.
; Registers Used:
;   RC = delay counter  
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    keypad_update
            
            push    rc                  ; save delay register

            call    i2c_wrbuf           ; i2c address = $4B
            db      I2C_ADDR, 2         ; send two byte command to update I2C
            dw      key_fifo            ; register with value from FIFO stack
            lbdf    err_exit            ; DF=1 means write failed, so abandon

            load    rc, DELAY_20MS      ; wait 20 ms after update
            call    util_delay            
            
            clc                         ; make sure DF=0 for success
err_exit:   pop     rc                  ; restore delay register
            return

key_fifo:   db KEYPAD_FIFO,$01          ; update with value from FIFO stack

            endp
