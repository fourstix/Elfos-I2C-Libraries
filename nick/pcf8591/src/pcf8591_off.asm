;-------------------------------------------------------------------------------
; pcf8591_off - a function to turn off the analog output on the pcf8591 8 Bit 
; A/D D/A with I2C using the PIO and I2C Expansion Boards for the 1802/Mini .
; Computer.
;
; Copyright 2023 Milton 'Nick' DeNicholas
;
; This is an extension of Copyrighted work by Gaston Williams
; please see https://github.com/fourstix/Elfos-I2C-Libraries for more info
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
;-------------------------------------------------------------------------------

#include ../../include/ops.inc
#include ../../include/bios.inc
#include ../../include/kernel.inc
#include ../../include/sysconfig.inc
#include ../../include/i2c_lib.inc
#include ../../include/pcf8591_def.inc

;-------------------------------------------------------------------------------
; This routine turns off analog output, resets device to pcf8591_init_s0 state.
; I2C_ADDR is defined in the pcf8591_def.inc file above
;
; Example:
;           call    pcf8591_off        ; initialize device to:
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    pcf8591_off
            
            call    i2c_wrbuf          ; write to pcf8591, chnl 0, analog output off
            db      I2C_ADDR , $02     ;    where 12c addr = I2C_ADDR for 2 bytes
            dw      pcf8591off         ; 
            return
                        
pcf8591off: db    $00                  ; Control Byte: Analog Output off, remainder = _s0 config
            db    pcf8591_DAC          ; DAC value

            
            endp
            