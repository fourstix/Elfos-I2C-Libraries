;-------------------------------------------------------------------------------
; relay_read_state - a routine to read the state of a Sparkfun
; Qwiic single relay with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
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
; Sparkfun Qwiic Single Relay
; Copyright 2019-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15093 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/relay_def.inc


;-------------------------------------------------------------------------------
; This routine reads the state byte from the relay
; Returns: 
;     D  = relay state, 0 if off, 1 if on
;     DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    relay_get_state
            push    rd                ; save index register
            
            call    i2c_rdreg
            db      I2C_ADDR
            db      1, RELAY_STATE
            db      1                 ; read 1 bute relay state from register
            dw      rly_state
            lbdf    err_exit          ; DF=1 means read failed
            
            load    rd, rly_state  
            ldn     rd                ; get the state byte
            plo     re                ; save in Elf/os scratch register (RE.0)
            
err_exit:   pop     rd                ; restore rd
            glo     re                ; restore D from Elf/os scratch register
            return

rly_state:  db     $00                ; relay state byte

            endp
