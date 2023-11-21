;-------------------------------------------------------------------------------
; tsl2561_power_on - a function to power up and configure the 
; TSL2561 LUX Sensor with I2C using the PIO and I2C Expansion Boards for 
; the 1802/Mini Computer.
;
; Sensor details see ==> https://learn.adafruit.com/tsl2561?view=all
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
#include ../../include/tsl2561_def.inc

;-------------------------------------------------------------------------------
; This routine powers up the TSL2561 and configures the i2c device whose
; address is defined in the tsl2561_def.inc file above
;
; Example: 
;   The following instructs the TSL2561 to power up & use Word mode
;           call    tsl2561_power_on   ; turn on tsl2561 integration, and configures
;                                      ; word mode communications (16bit / 2 bytes)
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    tsl2561_power_on
            
            call    i2c_wrbuf          ; write to tsl2561 device
            db      I2C_ADDR , $02     ;    where i2c addr = I2C_ADDR for 2 bytes
            dw      pwron              ; message buffer
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
pwron:      db    TSL2561_COMMAND_BIT+TSL2561_REGISTER_CONTROL+TSL2561_WORD_BIT   ; tsl2561 command code
            db    TSL2561_CONTROL_POWERON    ; Control Register = Power on
            
            endp
            