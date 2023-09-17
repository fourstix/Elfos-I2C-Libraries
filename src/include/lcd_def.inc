;-------------------------------------------------------------------------------
; This library contains routines to support a Liquid Crystal
; display with I2C running from an 1802-Mini Computer with the PIO and 
; I2C Expansion Boards. These routines are meant to be called using SCRT 
; in Elf/OS with X=R2 being the stack pointer.
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
; I2C 16x2 Liquid Crystal Display and I2C 20x4 Liquid Crystal Display 
; Copyright 2015-2023 by SunFounder
; Please see https://www.sunfounder.com/products/i2c-lcd1602-module and 
; https://www.sunfounder.com/products/i2c-lcd2004-module for more info.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Constants used by I2C Liquid Crystal display
;-------------------------------------------------------------------------------

I2C_ADDR:   equ       027h

; enable pulse bit masks
#define LCD_EN_ON     $04
#define LCD_EN_OFF    $FB 

; send command / data with backlight on (default) 
#define LCD_CMD       $08
#define LCD_DATA      $09

; send command / data with backlight off 
#define LCD_CMD_DRK   $00
#define LCD_DATA_DRK  $01


; display hard reset command bytes
#define LCD_RESET     $00
#define LCD_SETUP     $30
#define LCD_4BIT      $20 

; multiple-line, 4-bit, 5x8 char
#define LCD_DEVICE    $28

; default Latin-1 entry mode
#define LCD_ENTRY     $06

; display clear command
#define LCD_CLEAR     $01

; display home command
#define LCD_HOME      $02

; cursor position command
#define LCD_POSITION  $80

; custom character command
#define LCD_BITMAP    $40

; display control byte (default) 
#define LCD_DISPLAY   $0C

; scroll display left
#define LCD_SCROLL_L  $18

; scroll display right
#define LCD_SCROLL_R  $1C


; display control bit masks
#define LCD_BLINK     $01
#define LCD_NOBLINK   $FE
#define LCD_CURSOR    $02
#define LCD_NOCURSOR  $FD
#define LCD_ON        $04
#define LCD_OFF       $FB

; entry mode control bit masks
#define LCD_L_TO_R    $02
#define LCD_R_TO_L    $FD
#define LCD_AUTO      $01
#define LCD_NOAUTO    $FE

;-------------------------------------------------------------------------------
; Control bytes used by I2C Liquid Crystal Display library
;-------------------------------------------------------------------------------
            extrn   disp_ctrl 
            extrn   data_ctrl 
            extrn   cmd_ctrl 
            extrn   entry_ctrl 
            
;-------------------------------------------------------------------------------
; Routines used by I2C Liquid Crystal Display library
;-------------------------------------------------------------------------------
            
            extrn   lcd_send_byte
            extrn   lcd_send_cmd
            extrn   lcd_send_data
            extrn   lcd_reset
            extrn   lcd_clear
            extrn   lcd_home
            extrn   lcd_update
            extrn   lcd_entry_mode
