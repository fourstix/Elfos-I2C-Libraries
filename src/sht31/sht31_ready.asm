;-------------------------------------------------------------------------------
; sht31_ready - a routine to check the ready status of an SHT31 temperature
; and humidity sensor with I2C using the PIO Expansion Board and 
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
#include ../include/sht31_def.inc


;-------------------------------------------------------------------------------
; This routine checks if the sensor is ready to take a reading by reading the
; status buffer.  The lower byte of the buffer contains bit-flags for various 
; error conditions. If any of these bits are set, then the sht31_init function
; should be called before taking a reading.  If these bits are all zero, then
; the sensor is still initialized and ready to take another reading.
; Returns: 
;   D  = 0, if NOT ready (initialization required); D = 1 if ready (initialized) 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_ready
            
            push    rd
            
            call    i2c_rdreg           ; read status register
            db      I2C_ADDR
            db      2                   ; 2 byte register address
            dw      STATUS_REG          
            db      3                   ; read 3 bytes (2 status bytes + CRC byte)
            dw      status_buf
            lbdf    rdy_exit            ; if error, exit immediately
            
            ldi     1                   ; default to ready return value
            plo     re                  ; save in Elf/os scratch register

            load    rd, status_buf + 1  ; get the status LSB
            ldn     rd                  ; get byte with the reset and error bits
            lbz     rdy_exit            ; if zero, return with 1 (ready)
                        
            ldi     0                   ; if any error, return with 0 (NOT ready)                            
            plo     re                  ; save in Elf/os scratch register
                          
rdy_exit:   pop rd
            glo     re                  ; get value for D 
            return

status_buf: db      0,0,0

            endp
