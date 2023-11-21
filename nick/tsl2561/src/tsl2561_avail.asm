;-------------------------------------------------------------------------------
; tsl2561_avail - a function to check the i2c bus for the presence of a 
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
; This routine checks the i2c bus for the presence of an i2c device whose
; address is defined in the tsl2561_def.inc file above
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    tsl2561_avail
            
            call    i2c_avail
            db      I2C_ADDR           ; see if tsl2561 lux sensor is online
            
            return
            endp
            