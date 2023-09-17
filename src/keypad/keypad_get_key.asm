;-------------------------------------------------------------------------------
; keypad_get_button - a routine to read the button from a
; Sparkfun Qwiic 12 Button Keypad with I2C using the PIO and
; I2C Expansions Boards for the 1802/Mini Computer.
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
; Get the button from the keypad as a byte value.
; Registers Used:
;   RF = buffer pointer
;   RC = delay counter   
; Returns: 
;   D = key value, 0 = No key available, -1 = Error 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    keypad_get_key
            push    rf
            push    rc
            
            ldi     $FF                 ; set Elf/OS scratch register to error value
            plo     re                
            
            call    i2c_rdreg           ; i2c address = $4B
            db      I2C_ADDR
            db      1, KEYPAD_KEY       ; 1 byte register address 
            db      1                   ; read 1 byte from register 3
            dw      key_buf             ; buffer for key value
            lbdf    err_exit            ; if unable to read keypad, exit immediately

            load    rc, DELAY_20MS      ; wait 20 ms after read
            call    util_delay

            load    rf, key_buf         ; get key value from buffer
            ldn     rf                  
            plo     re                  ; put key value in scratch register
            
            clc                         ; make sure DF = 0            
err_exit:   pop     rc                  ; restore registers used
            pop     rf
            glo     re                  ; get key value for return
            return

key_buf:    db 0                        ; key buffer

            endp
