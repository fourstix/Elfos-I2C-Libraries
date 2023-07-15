;-------------------------------------------------------------------------------
; sht31_get_heater - a routine to get the heater status from the SHT31 
; temperature and humidity sensor with I2C using the PIO Expansion Board and 
; I2C adaptor for the 1802/Mini Computer with the RTC Expansion card.
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
; Adafruit SHT31 Temperature & Humidity Sensor
; Copyright 2019-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/2857 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/util_lib.inc
#include ../include/sht31_def.inc

;-------------------------------------------------------------------------------
; This routine reads the heater status for the sensor
; Returns: 
;     D  = 0, if heater is off; D = 1 if heater is on
;     DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_get_heater
            
            push    rd
            
            call    i2c_rdreg         ; read status register
            db      I2C_ADDR          
            db      2                 ; 2 byte register address
            dw      STATUS_REG     
            db      3                 ; read 3 bytes (2 status bytes + CRC byte)
            dw      sensor_buf
            lbdf    err_exit          ; DF=1 means read failed
            
            load    rd, sensor_buf 
            ldn     rd                ; get byte with the heater bit
            ani     HEATER_BIT        ; mask off all but heater bit
            lsz                       ; if off, just save zero in scratch register            
            ldi     1                 ; if on, put 1 in scratch register
                
            plo     re                ; save flag in Elf/os scratch register
              
err_exit:   pop rd
            glo     re                ; get value for D 
            return

sensor_buf: db      0,0,0

            endp
