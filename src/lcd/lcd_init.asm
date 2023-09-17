;-------------------------------------------------------------------------------
; lcd_init - initialize the Liquid Crystal Display with I2C using
; the PIO and I2C Expansion Boards for the 1802/Mini Computer.
;
; Copyright 2023 by Gaston Williams
;
; Based on the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022-2023 by Tony Hefner 
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
; Initialize the I2C Liquid Crystal display
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_init
            
            call    lcd_reset       ; reset the displays
            lbdf    err_exit        ; if error, exit immediately
              
            ldi     LCD_DEVICE      ; set device 2/4 lines, 5x8 font, 4-bits
            call    lcd_send_cmd    ; send device command
            lbdf    err_exit        ; if error, exit immediately

            ldi     LCD_DISPLAY     ; turn display on, no cursor, no blink
            call    lcd_send_cmd    ; send display command
            lbdf    err_exit        ; if error, exit immediately
            
            call    lcd_clear
            lbdf    err_exit        ; if error, exit immediately
                        
            ldi     LCD_ENTRY       ; set entry mode for Latin languages
            call    lcd_send_cmd    ; send display command
            lbdf    err_exit        ; if error, exit immediately

            call    lcd_home
            lbdf    err_exit        ; if error, exit immediately

            ;-----  display is ready
              
            clc  
err_exit:   return
          
            endp
