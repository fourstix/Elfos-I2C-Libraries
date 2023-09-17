;-------------------------------------------------------------------------------
; lcd_send_cmd - send a command byte to the Liquid Crystal Display with
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
; Send a command byte to the  Liquid Crystal display in 4-bit mode.
; Parameters:
;   D = byte value for command  
; Registers Used:
;   RF = index pointer
;   RD.1 = command byte
;   RD.0 = nibble as byte value to send to display   
;   RC = control byte pointer   
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_send_cmd
            plo     re              ; save command byte in ELf/OS scratch register
            push    rf              ; save registers
            push    rd
            push    rc
            
            glo     re              ; get command byte
            phi     rd              ; save command byte in rd.1
            
            load    rc, cmd_ctrl    ; point to command control byte
            ldn     rc              ; get the bit mask for command
            str     r2              ; save in M(X)

            ;----- send the high nibble of command to display
            ghi     rd              ; get command byte
            ani     $F0             ; mask off high bits of nibble
            or                      ; OR with command bit mask in M(X)
            plo     rd              ; save in rd.0 to send to display
            
            ; send the byte with nibble to the display
            call    lcd_send_byte 
            lbdf    err_exit        ; if error, exit immediately

            ldn     rc              ; get bit mask for command
            str     r2              ; save in M(X)

            ;----- send the low nibble of command to display
            ghi     rd              ; get command byte
            ani     $0F             ; mask off low bits of nibble
            shl                     ; shift lower 4 bits into high 4 bits
            shl                     ; filling low bits with zero
            shl
            shl                     ; low nibble in high 4 bits
            or                      ; OR command bit mask in M(X)
            plo     rd              ; save in rd.0 to send to display

            ; send the byte with nibble to the display
            call    lcd_send_byte 
            
err_exit:   pop     rc              ; restore registers
            pop     rd
            pop     rf                  
            return              
            endp

;-------------------------------------------------------------------------------
; Command bit mask for an I2C Liquid Crystal display
;-------------------------------------------------------------------------------
            proc    cmd_ctrl            
            db LCD_CMD          ; default command bits (RS off, Backlight on)
            endp
            
