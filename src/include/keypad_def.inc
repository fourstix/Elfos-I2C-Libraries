;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun Qwiic 12 Button 
; Keypad with I2C running from an 1802-Mini Computer with the PIO and I2C 
; Expansion Boards. 
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
;
; Sparkfun Qwiic 12 Button Keypad hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15290 for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by Sparkfun Qwiic Keypad
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     04bh

;-------------------------------------------------------------------------------
; Register values for Sparkfun Qwiic Keypad
;-------------------------------------------------------------------------------

KEYPAD_ID:    equ 00h
KEYPAD_VER:   equ 01h         ; 2 bytes (Major, Minor)
KEYPAD_KEY:   equ 03h
KEYPAD_TIME:  equ 04h         ; 2 bytes (MSB, LSB)
KEYPAD_FIFO:  equ 06h
