;-------------------------------------------------------------------------------
; lcd_home - set the cursor to (0,0) on a Liquid Crystal Display with 
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
; Position the cursor on a  Liquid Crystal display
; Parameters:
;   RD.1 = col 
;   RD.0 = row
; Registers Used:
;   RF = offset pointer   
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_position
            push    rf        ; save offset pointer

            ; point to table of row offset values 
            load    rf, row_offset
            
            glo     rf        ; adjust offset for rows
            str     r2        ; save in M(X)
            glo     rd        ; get row value (0-3)
            add               ; add to offset
            plo     rf        ; save in offset pointer
            ghi     rf        ; update high byte with carry flag
            adci    0
            phi     rf        ; save updated offset pointer

            ldn     rf        ; get the offset
            str     r2        ; save in M(X)
            ghi     rd        ; get the column value
            add               ; add offset to column
            
            ; set cursor position bit on
            ori     LCD_POSITION  
            
            ; send byte as cursor position command
            call    lcd_send_cmd
            
            pop     rf        ; restore offset pointer
            return 
            
row_offset: db 0, $40, $14, $54
            endp
