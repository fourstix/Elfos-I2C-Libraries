;-------------------------------------------------------------------------------
; sht31_read_status - a routine to get the 16-bit status word from the SHT31 
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
; This routine reads the status information from the sensor into a register.
; Regisers Used:
;   RF - pointer to status buffer
; Returns: 
;   RD  = 16-bit status value
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_read_status
            
            push    rf                  ; save buffer pointer
            
            call    i2c_rdreg
            db      I2C_ADDR
            db      2                   ; 2 byte register address
            dw      STATUS_REG       
            db      3                   ; read 3 bytes (2 status bytes + CRC byte)
            dw      sensor_buf
            lbdf    err_exit            ; DF=1 means read failed
            
            load    rf, sensor_buf      ; point to status buffer
            lda     rf                  ; get status MSB 
            phi     rd                  ; put in high byte
            ldn     rf                  ; get status LSB
            plo     rd                  ; put in low byte
            
            
err_exit:   pop rf                      ; restore buffer pointer
            return

sensor_buf: db      0,0,0

            endp
