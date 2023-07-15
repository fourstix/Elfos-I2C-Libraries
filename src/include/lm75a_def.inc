;-------------------------------------------------------------------------------
; This library contains definitions to support an LM75A temperature sensor
; with I2C running from an 1802-Mini Computer with the PIO and I2C Expansion
; Boards. 
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2022 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by LM75A temperature sensor
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     $48


;-------------------------------------------------------------------------------
; Register values for LM75A temperature sensor
;-------------------------------------------------------------------------------

TEMP_REG:   equ 00h
