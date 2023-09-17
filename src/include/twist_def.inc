;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun Qwiic Twist 
; RGB Rotary Encoder with I2C running from an 1802-Mini Computer with
; the PIO and I2C Expansion Boards. 
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
; Sparkfun Qwiic Twist RGB Rotary Encoder hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15083 for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by Sparkfun Qwiic Twist RGB Rotary Encoder
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     03Fh

;-------------------------------------------------------------------------------
; Register values for Sparkfun Twist RGB Rotary Encoder
;-------------------------------------------------------------------------------

TWIST_STATUS:         equ 01h   ; status byte
TWIST_VERSION:        equ 02h   ; twist firmware version
TWIST_COUNT:          equ 05h   ; encoder count
TWIST_DIFF:           equ 07h   ; change in encoder count
TWIST_CLICK:          equ 09h   ; milliseconds since encoder click
TWIST_BTN:            equ 0Bh   ; milliseconds since button press
TWIST_COLOR:          equ 0Dh   ; RGB color (3 bytes, 1 byte each for r, g, b)
TWIST_CHG_R:          equ 10h   ; amount to change red LED for each encoder tick
TWIST_CHG_G:          equ 12h   ; amount to change green LED for each encoder tick
TWIST_CHG_B:          equ 14h   ; amount to change blue LED for each encoder tick
