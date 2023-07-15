;-------------------------------------------------------------------------------
; relay_get_version - a routine to read the firmware version of a Sparkfun
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
; This routine reads the firmware version from the relay
; Returns: 
;   RF = pointer to firmware version string
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    relay_get_version
            push    rd                ; save index register
            
            call    i2c_rdreg
            db      I2C_ADDR
            db      1, RELAY_VERSION  ; 1 byte register address
            db      2                 ; read 2 version bytes
            dw      rly_vbytes
            lbdf    err_exit          ; DF=1 means read failed
            
            load    rd, rly_vbytes
            load    rf, rly_vstr+1    ; major character is after 'v' in string
            
            lda     rd                ; get major byte
            adi     '0'               ; add ascii offset
            str     rf                ; put in version string
            inc     rf                ; point rf to minor char
            inc     rf                ; by skipping over decimal point
            ldn     rd                ; get minor byte
            adi     '0'               ; add ascii offset
            str     rf                ; save in version string            
            
            load    rf, rly_vstr      ; point rf to version string
err_exit:   pop     rd                ; restore index register
            return

rly_vbytes: db     $00, $00           ; version major and minor bytes
rly_vstr:   db     'v0.0',0           ; relay version string

            endp
