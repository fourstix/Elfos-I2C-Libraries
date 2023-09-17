;-------------------------------------------------------------------------------
; lcd_send_data - send a data byte to the Liquid Crystal Display with
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
; Send a data byte to the  Liquid Crystal display in 4-bit mode.
; Parameters:
;   D = byte value for data  
; Registers Used:
;   RF = index pointer
;   RD.1 = data byte
;   RD.0 = nibble as byte value to send to display
;   RC = control byte pointer   
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_send_data
            plo     re              ; save data byte in ELf/OS scratch register

            push    rf              ; save registers used
            push    rd
            push    rc
            
            glo     re              ; get data byte
            phi     rd              ; save data byte in rd.1
            
            load    rc, data_ctrl   ; point to data control byte buffer
            ldn     rc              ; get the bit mask for data
            str     r2              ; save in M(X)
                        
            ;----- send the high nibble of data to display
            ghi     rd              ; get bit mask for sending data
            ani     $F0             ; mask off high bits of nibble
            or                      ; or with data bit mask in M(X)
            plo     rd              ; save in rd.0 to send to display
            
            ; send the byte to the display
            call    lcd_send_byte 
            lbdf    err_exit        ; if error, exit immediately

            ldn     rc              ; get the bit mask for data
            str     r2              ; save in M(X)

            ;----- send the low nibble of data to display
            ghi     rd              ; get data bit mask
            ani     $0F             ; mask off low bits of nibble
            shl                     ; shift lower 4 bits into high 4 bits
            shl
            shl
            shl
            or                      ; or with data bit mask in M(X)
            plo     rd              ; save in rd.0 to send to display

            ; send the byte to the display
            call    lcd_send_byte 
            
err_exit:   pop     rc              ; restore registers used
            pop     rd
            pop     rf                  
            return              
            endp
            
            ;-------------------------------------------------------------------------------
            ; Data bit mask for an I2C Liquid Crystal display
            ;-------------------------------------------------------------------------------

            proc    data_ctrl            
            db LCD_DATA         ; default data bits (RS on, Backlight on)
            endp
