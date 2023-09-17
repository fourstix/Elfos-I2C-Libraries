;-------------------------------------------------------------------------------
; lcd_send_byte - send a byte to the  Liquid Crystal Display with
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
; Send a byte value to the Liquid Crystal display
; Parameters:
;   RD.0 = byte value to send  
; Registers Used:
;   RF = buffer pointer
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_send_byte
            push    rf                  ; save buffer pointer register
            
            load    rf, send_byte       ; point to byte buffer
            glo     rd                  ; get byte value
            str     rf                  ; save byte value in buffer

            inc     rf                  ; point to pulse enable buffer
            glo     rd                  ; get byte value
            ori     LCD_EN_ON           ; set enable bit on
            str     rf                  ; save value in buffer  
            
            inc     rf                  ; point to pulse disable buffer
            glo     rd                  ; get byte value
            ani     LCD_EN_OFF          ; turn enable bit off
            str     rf                  ; save value in buffer  
            
            call    i2c_wrbuf           ; send byte toggling EN bit to pulse
            db      I2C_ADDR, 3         ; send 3 bytes to device
            dw      send_byte           ; buffer with bytes to send
            
err_exit:   pop     rf                  ; restore buffer pointer register                 
            return              

send_byte:  db 0    ; byte value to send
pulse_on:   db 0    ; byte value with pulse bit enabled
pulse_off:  db 0    ; byte value with pulse bit disabled 
            endp
