;-------------------------------------------------------------------------------
; lcd_backlight_on - turn on the backlight for a Liquid Crystal Display
; with I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
;
; Copyright 2023 by Gaston Williams
;
; Based on the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
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

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/util_lib.inc
#include ../include/lcd_def.inc

;-------------------------------------------------------------------------------
; Turn on the backlight for an I2C Liquid Crystal display
; Registers Used:
;   RF = pointer to control byte  
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_backlight_on
            push    rf              ; save pointer register

            load    rf, data_ctrl   ; set the data control bit mask
            ldi     LCD_DATA        ; RS bit on, backlight bit on 
            str     rf              ; save data control bit mask

            load    rf, cmd_ctrl    ; set the command control bit mask
            ldi     LCD_CMD         ; RS bit off, backlight bit on 
            str     rf              ; save data control bit mask

            call    lcd_update      ; update display to turn backlight on
            
            pop     rf              ; restore pointer register              
            return            
            endp
