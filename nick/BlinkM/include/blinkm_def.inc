;-------------------------------------------------------------------------------
; blinkm - a library for using the BlinkM smart LED
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
; BlinkM - Constants used by the blinkm smart LED
;-------------------------------------------------------------------------------


I2C_ADDR:   equ     $09                ; Default is $09, can be changed to any addr

;------------------------------------------------------------------------------
;    BASIC RGB COLORS (Red, Green, Blue)
;
;  See ==> https://en.wikipedia.org/wiki/RGB_color_model
;  for more detailed color definitions for R, G, and B
;
;------------------------------------------------------------------------------

#define C_WHITE         $FF,$FF,$FF
#define C_BLACK         $00,$00,$00
#define C_RED           $FF,$00,$00
#define C_BLUE          $00,$00,$FF
#define C_GREEN         $00,$FF,$00
#define C_GREY          $80,$80,$80
#define C_YELLOW        $FF,$FF,$00
#define C_ORANGE        $FF,$80,$00
#define C_PINK          $FF,$00,$FF
#define C_PURPLE        $80,$00,$FF
#define C_TEAL          $80,$FF,$FF


;------------------------------------------------------------------------------
;    BASIC HSV COLORS (Hue Saturation and Value)
;
;  See ==> https://en.wikipedia.org/wiki/List_of_colors:_A%E2%80%93F
;  for more detailed color definitions for H, S, and V
;
;------------------------------------------------------------------------------

#define H_WHITE         $00,$00,$64
#define H_BLACK         $00,$00,$00
#define H_RED           $00,$64,$64
#define H_BLUE          $F0,$64,$64
#define H_GREEN         $78,$64,$64
#define H_GREY          $00,$00,$32
#define H_YELLOW        $3C,$64,$64
#define H_ORANGE        $1E,$64,$64


