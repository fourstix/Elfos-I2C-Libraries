;-------------------------------------------------------------------------------
; tsl2561 - a library for using the Adafruit TSL2561 LUX sensor
; with I2C via the PIO Expansion Board for the 1802/Mini Computer
; with the RTC Expansion card. 
;
; Sensor details see ==> https://learn.adafruit.com/tsl2561?view=all
;
; Copyright 2023 by Nick DeNicholas
;
; I2C software library and code from the fourstix github
; repository here ==> https://github.com/fourstix/Elfos-I2C-Libraries/tree/main
;
; Based on program code in the Elf-I2C library Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; TSL2561 - Constants used by the tsl2561 device 
; 
; Based on source from Adafruit at ... 
; https://github.com/adafruit/Adafruit_TSL2561/blob/master/Adafruit_TSL2561_U.h
;
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; I2C Address
;------------------------------------------------------------------------------
I2C_ADDR:   equ     $39                ; Default is $39, can also be $29 or $49


;------------------------------------------------------------------------------
; Three options for how long to integrate readings for 
;------------------------------------------------------------------------------
#define     TSL2561_INTEGRATIONTIME_13MS      $00   ; 13.7ms
#define     TSL2561_INTEGRATIONTIME_101MS     $01   ; 101ms
#define     TSL2561_INTEGRATIONTIME_402MS     $02   ; 402ms


;------------------------------------------------------------------------------
; TSL2561 offers 2 gain settings 
;------------------------------------------------------------------------------
#define     TSL2561_GAIN_1X      $00    ; No gain
#define     TSL2561_GAIN_16X     $10    ; 16x gain


;------------------------------------------------------------------------------
; TSL2561 Manual Integration control, INTEG field = $03 + start/stop 
;------------------------------------------------------------------------------
#define     TSL2561_MAN_OFF    $03     ; Manual integration stop
#define     TSL2561_MAN_ON     $0B     ; Manual integration start


;------------------------------------------------------------------------------
; Channels
;------------------------------------------------------------------------------
#define TSL2561_INFRARED        $01      ; channel 1
#define TSL2561_FULLSPECTRUM    $00      ; channel 0


;------------------------------------------------------------------------------
; TSL2561 I2C Registers
;------------------------------------------------------------------------------
#define     TSL2561_REGISTER_CONTROL           $00  ; Control/power register
#define     TSL2561_REGISTER_TIMING            $01  ; Set integration time register
#define     TSL2561_REGISTER_THRESHHOLDL_LOW   $02  ; Interrupt low threshold low-byte
#define     TSL2561_REGISTER_THRESHHOLDL_HIGH  $03  ; Interrupt low threshold high-byte
#define     TSL2561_REGISTER_THRESHHOLDH_LOW   $04  ; Interrupt high threshold low-byte
#define     TSL2561_REGISTER_THRESHHOLDH_HIGH  $05  ; Interrupt high threshold high-byte
#define     TSL2561_REGISTER_INTERRUPT         $06  ; Interrupt settings
#define     TSL2561_REGISTER_ID                $0A  ; TSL2561 identification setting
#define     TSL2561_REGISTER_CHAN0_LOW         $0C  ; Light data channel 0, low byte
#define     TSL2561_REGISTER_CHAN0_HIGH        $0D  ; Light data channel 0, high byte
#define     TSL2561_REGISTER_CHAN1_LOW         $0E  ; Light data channel 1, low byte
#define     TSL2561_REGISTER_CHAN1_HIGH        $0F  ; Light data channel 1, high byte


;------------------------------------------------------------------------------
;  Control Params
;------------------------------------------------------------------------------
#define TSL2561_COMMAND_BIT                $80 ;  Must be 1
#define TSL2561_CLEAR_BIT                  $40 ;  Clears any pending interrupt (write 1 to clear)
#define TSL2561_WORD_BIT                   $20 ;  1 = read/write word            rather than byte)
#define TSL2561_BLOCK_BIT                  $10 ;  1 = using block read/write

#define TSL2561_CONTROL_POWERON            $03 ;  Control register setting to turn on
#define TSL2561_CONTROL_POWEROFF           $00 ;  Control register setting to turn off

