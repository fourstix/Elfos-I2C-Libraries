;-------------------------------------------------------------------------------
; mem_avail - a routine to check the i2c bus for the presence of an 
; I2C memory device such as an Adafruit Non-Volatile Fram Breakout board
; or a Sparkfun Qwiic EEPROM Break board with I2C using the PIO 
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
; Adafruit Non-Volatile Fram Breakout Board
; Copyright 2014-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/1895 for more info
;
; Sparkfun Qwiic EEPROM Breakout Board
; Copyright 2018-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/products/18355 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/util_lib.inc
#include ../include/mem_def.inc


;-------------------------------------------------------------------------------
; This routine checks the i2c bus for the presence of an SHT31 sensor
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    mem_avail
            
            call    i2c_avail
            db      I2C_ADDR

            return
            endp
