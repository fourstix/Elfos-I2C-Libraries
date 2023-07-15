;-------------------------------------------------------------------------------
; relay_set_off - a routine to send the command to turn off a Sparkfun
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
; This routine writes the command to the relay
;   DF = 0 on success, DF = 1 command failed
;-------------------------------------------------------------------------------

            proc    relay_set_off

            call    i2c_wrbuf
            db      I2C_ADDR
            db      1                 ; write 1 byte command to turn off relay
            dw      off_cmd
            return

off_cmd:    db     $00                ; relay off command

            endp
