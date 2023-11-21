;-------------------------------------------------------------------------------
; mcp23017 - a library for using the mcp23017 GPIO chip
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
; mcp23017 - Constants used by the gpio chip
;-------------------------------------------------------------------------------


I2C_ADDR:   equ     020h                ; GPIO could be 20 through 27

;;   Banks A and B
#define MCP23017_BANKA       $00        ; Bank A no offset to below registers
#define MCP23017_BANKB       $01        ; Bank B +1 offset to below registers

;;  Registers                           ; DESCRIPTION    
#define MCP23017_DDR         $00        ; Data Direction Register 
#define MCP23017_POL         $02        ; Input Polarity 
#define MCP23017_GPINTEN     $04        ; NOT USED interrupt enable
#define MCP23017_DEFVAL      $06        ; NOT USED interrupt def 
#define MCP23017_INTCON      $08        ; NOT USED interrupt control 
#define MCP23017_IOCR        $0A        ; IO control register 
#define MCP23017_PUR         $0C        ; Pull Up Resistors    
#define MCP23017_GPIO        $12        ; General Purpose IO   
#define MCP23017_OLAT        $14        ; NOT USED output latch   

;; Operational Definitions
#define MCP23017_OUTPUTS     $00        ; All 8 pins in bank are outputs
#define MCP23017_INPUTS      $FF        ; All 8 pins in bank are inputs

#define MCP23017_IN-NORM     $00        ; All 8 in pins in bank are normal
#define MCP23017_IN-INVR     $FF        ; All 8 in pins in bank are inverted

#define MCP23017_EN_INTS     $FF        ; All 8 pins enable ints on state change
#define MCP23017_DI_INTS     $00        ; All 8 pins disable ints on state change

#define MCP23017_EN_PUR      $FF        ; All 8 pins enable input pull up resistors
#define MCP23017_DI_PUR      $00        ; All 8 pins disable input pull up resistors

