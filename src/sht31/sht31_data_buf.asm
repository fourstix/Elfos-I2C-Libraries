;-------------------------------------------------------------------------------
; sht31_data_buf - buffer for the temperature and relative humidity data read 
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

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/sht31_lib.inc 

;-------------------------------------------------------------------------------
; Six-byte data buffer used by the other routines
;-------------------------------------------------------------------------------

            proc sht31_data_buf 
            
            db 0,0            ; 16-bit temperature reading 
            db 0              ; CRC byte
            db 0,0            ; 16-bit humidity reading
            db 0              ; CRC byte
            
            endp
