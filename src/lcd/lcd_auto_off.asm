;-------------------------------------------------------------------------------
; lcd_auto_off - turn autoscroll off for a Liquid Crystal Display with 
; I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
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
; Turn autoscroll off for an I2C Liquid Crystal display
; Registers Used:
;   RF = pointer to display control byte  
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_auto_off
            push    rf              ; save pointer register

            load    rf, entry_ctrl  ; get the entry mode control byte
            ldn     rf  
            ani     LCD_NOAUTO      ; clear the autoscroll bit
            str     rf              ; save updated display control byte
            
            call    lcd_entry_mode  ; update the entry mode   
            
            pop     rf              ; restore pointer register                       
            return            
            endp
