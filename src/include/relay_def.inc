;-------------------------------------------------------------------------------
; This library contains definitions to support a Sparkfun
; Qwiic single relay with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
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
; Sparkfun Qwiic Single Relay
; Copyright 2019-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15093 for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by Sparkfun Qwiic Relay
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     $18


;-------------------------------------------------------------------------------
; Register values for Sparkfun Qwiic Relay
;-------------------------------------------------------------------------------

RELAY_VERSION:  equ $04
RELAY_STATE:    equ $05
