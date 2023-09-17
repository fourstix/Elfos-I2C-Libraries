;-------------------------------------------------------------------------------
; This library contains definitions to support an I2C memory device
; such as an Adafruit Non-Volatile Fram Breakout board or a Sparkfun
; Qwiic EEPROM Breakout board with I2C using the PIO Expansion Board
; and I2C adaptor for the 1802/Mini Computer with the RTC Expansion card.
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
; Adafruit Non-Volatile Fram Breakout Board
; Copyright 2014-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/1895 for more info
;
; Sparkfun Qwiic EEPROM Breakout Board
; Copyright 2018-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/products/18355 for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by Adafruit Non-Volatile Fram Breakout Board
;-------------------------------------------------------------------------------

I2C_ADDR:       equ     $50
