;-------------------------------------------------------------------------------
; lcd_create_char - create a custom character for a Liquid Crystal Display 
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
; Create a custom character for an I2C Liquid Crystal display
; Parameters:
;   RF = pointer to 8x5 character bitmap
;   D  = character index (0 to 7)  
; Registers Used:
;   RC.0 = byte counter  
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_create_char
            plo     re              ; save index in Elf/os scratch register
            
            push    rc              ; save byte counter register

            ldi     08              ; eight bytes in character bitmap
            plo     rc              ; set byte counter
                                    
            glo     re              ; get character index
            ani     $07             ; must be 0 to 7
            shl                     ; shift left 3 bits
            shl 
            shl 
            ori     LCD_BITMAP      ; set character create bit
            
            call    lcd_send_cmd    ; send character create command
            lbdf    err_exit        ; if cannot send command, exit immediately


load_bmp:   lda     rf              ; get byte from character bitmap 
            call    lcd_send_data
            lbdf    err_exit        ; if can't send byte, exit immediately
            
            dec     rc              ; count down
            glo     rc              ; check count of bytes sent
            lbnz    load_bmp        ; keep going until all 8 bytes sent
            
            ; after loading the character we must home cursor
            call    lcd_home        
              
err_exit:   pop     rc              ; restore byte counter register           
            return      
                  
            endp
