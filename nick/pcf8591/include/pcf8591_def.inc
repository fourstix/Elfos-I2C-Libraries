;-------------------------------------------------------------------------------
; pcf8591 - a library for using the PCF8591 8bit A/D and D/A converter chip
; with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Nick DeNicholas
;
; I2C software library and code from the fourstix github
; repository here ==> https://github.com/fourstix/Elfos-I2C-Libraries/tree/main
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;PCF8591 - Constants used by the chip
;-------------------------------------------------------------------------------


I2C_ADDR:   equ     $48                ; Default is $48, can be $48-$4F

;------------------------------------------------------------------------------
;  Control Byte Defines - 2nd byte transmitted to the chip over i2c
;------------------------------------------------------------------------------

#define     AD_CHNL_0             $00
#define     AD_CHNL_1             $01
#define     AD_CHNL_2             $02
#define     AD_CHNL_3             $03

#define     AUTO_INCR             $04

#define     AD_INP_4SINGLE        $00
#define     AD_INP_3DIFF          $10
#define     AD_INP_2S_1DIFF       $20
#define     AD_INP_2DIFF          $30

#define     AOUT_ENABLE           $40

;------------------------------------------------------------------------------
;  DAC Defines - 3nd byte transmitted to the chip over i2c, % of AREF voltage
;------------------------------------------------------------------------------

#define     pcf8591_DAC           127                ; adjust as needed, then
                                                     ; re-assemble library
