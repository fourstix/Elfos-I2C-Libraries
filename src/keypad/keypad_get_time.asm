;-------------------------------------------------------------------------------
; keypad_get_time - a routine to get the number of milliseconds since 
; a key was last pressed on a Sparkfun Qwiic 12 Button Keypad with I2C 
; using the PIO and I2C Expansions Boards for the 1802/Mini Computer.
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
; Get the number of milliseconds since a key was last pressed as a 16-bit
; unsigned integer value.
; Registers Used:
; unsigned value.
;   RF = index pointer
;   RC = delay counter   
; Returns: 
;   RD = 16-bit unsigned int milliseconds value (0 to 65535)
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    keypad_get_time
            push    rf
            push    rc
            
            call    i2c_rdreg           ; i2c address = $4B
            db      I2C_ADDR
            db      1, KEYPAD_TIME      ; 1 byte register address
            db      2                   ; read 2 bytes from register 4
            dw      t_key
            lbdf    err_exit            ; if unable to read time, exit immediately

            load    rc, DELAY_20MS      ; wait 20 ms after read
            call    util_delay


            load    rf, t_key           ; get time value from buffer
            lda     rf                  ; get MSB
            phi     rd                  ; put MSB of time in RD.1
            ldn     rf                  ; get LSB
            plo     rd                  ; put LSB of time in RD.0

            clc                         ; clear DF for successful return                              
err_exit:   pop     rc
            pop     rf
            return

t_key:      db 0,0
          
            endp
