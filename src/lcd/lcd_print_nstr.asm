;-------------------------------------------------------------------------------
; lcd_nstr - print up to n characters from a string to a Liquid Crystal
; Display at the cursor position with I2C using the PIO and I2C Expansion
; Boards for the 1802/Mini Computer.
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
; Write up to n characters from a string to the  Liquid Crystal display  
; at the cursor position.
; Parameters:
;   RF = pointer to string buffer
;   RC.0 = count of maximum characters to write
; Registers Used:
;   (RF points to next character after last character written)   
;   (RC is consumed)
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_print_nstr
            
chk_cnt:    glo     rc          ; check character count
            lbz     end_wr      ; when count is exhausted, we're done
            
            lda     rf          ; get character to write to display
            lbz     end_wr      ; if we hit the end of string, exit
            
            ; send character to display
            call    lcd_send_data
            lbdf    end_wr      ; if error, exit immediately
            
            dec     rc          ; count down
            lbr     chk_cnt     ; check for end of buffer              
            
end_wr:     return            
            endp
