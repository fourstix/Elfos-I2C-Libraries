;-------------------------------------------------------------------------------
; This library contains definitions to support an SHT31 temperature and 
; humidity sensor with I2C using the PIO Expansion Board and I2C adaptor
; for the 1802/Mini Computer with the RTC Expansion card.
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

;-------------------------------------------------------------------------------
; Constants used by SHT31 temperature and humidity sensor
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     $44

HEATER_BIT: equ     $20

;-------------------------------------------------------------------------------
; Register value for SHT31 temperature and humidity sensor
;-------------------------------------------------------------------------------

STATUS_REG: equ     $F32D
