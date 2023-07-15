;-------------------------------------------------------------------------------
; sht31_read_data - a routine to read the temperature and relative humidity data 
; from the SHT31 temperature and humidity sensor with I2C using the PIO 
; Expansion Board and I2C adaptor for the 1802/Mini Computer.
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
#include ../include/sht31_lib.inc
#include ../include/util_lib.inc
#include ../include/sht31_def.inc

;-------------------------------------------------------------------------------
; This routine sends the read temperature and humidity command to the sensor.
; Returns: 
;     RF = pointer to 6 byte data buffer
;     DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_read_data
            
            push    rc                  ; save delay counter
            
            call    i2c_wrbuf           ; send command to read temp/humidity
            db      I2C_ADDR, 2         ; write two bytes for command
            dw      read_cmd
            lbdf    err_exit            ; DF=1 means an error occurred
            
            mov     rc, DELAY_20MS      ; delay about 20 ms for reading to complete
            call    util_delay

            call    i2c_rdbuf           ; read temp/humidity data
            db      I2C_ADDR, 6         ; read 6 bytes into data buffer
            dw      sht31_data_buf
            lbdf    err_exit            ; DF=1 means an error occurred
                        
            load    rf, sht31_data_buf
            
err_exit:   pop     rc                  ; restore counter register
            return

read_cmd:   db      $24, $00            ; read temperature/humidity command
            endp
            
