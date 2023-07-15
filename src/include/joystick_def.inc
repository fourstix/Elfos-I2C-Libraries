;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun Qwiic Joystick
; with I2C running from an 1802-Mini Computer with the PIO and I2C Expansion
; Boards. These routines are meant to be called using SCRT in Elf/OS 
; with X=R2 being the stack pointer.
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
; Sparkfun Qwiic Joystick hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15168 for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by Sparkfun Joystick (also offsets into data buffer)
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     020h


;-------------------------------------------------------------------------------
; Register values for Sparkfun Joystick (also offsets into data buffer)
;-------------------------------------------------------------------------------

JOYSTICK_ID:    equ 00h
MAJOR_VERSION:  equ 01h
MINOR_VERSION:  equ 02h
X_POSITON_MSB:  equ 03h
X_POSITON_LSB:  equ 04h
Y_POSITON_MSB:  equ 05h
Y_POSITON_LSB:  equ 06h
BUTTON_DOWN:    equ 07h   ; button currently down
BUTTON_PRESSED: equ 08h   ; button clicked
; I2C_LOCK // 0x09 - not used in this code
; CHANGE_ADDRESS //0x0A - not used in this code
