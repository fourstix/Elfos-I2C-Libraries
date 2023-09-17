;-------------------------------------------------------------------------------
; lcd_reset - reset the Liquid Crystal Display with I2C using
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
; Initialize the  Liquid Crystal display
; Registers Used:
;   RD.0 = byte value
;   RC = delay counter   
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------
            proc    lcd_reset
            push    rd
            push    rc                  ; save delay counter register

            load    rc, DELAY_50MS      ; delay about 50 ms before reset
            call    util_delay

            call    i2c_wrbuf
            db      I2C_ADDR, 1         ; 1 byte in command
            dw      reset_cmd           ; send reset command
            lbdf    err_exit            ; if error, exit immediately

            ;---- wait half a second after reseting display
            load    rc, DELAY_500MS     ; delay half a second
            call    util_delay

            ;-------------------------------------------------------------------
            ; Put the LCD into 4 bit mode, according to the 
            ; Hitachi HD44780 datasheet, figure 24, pg 46,
            ; we have to send the setup command 3 times
            ; to change into 4 bit mode. 
            ;-------------------------------------------------------------------
            
            
            ldi     LCD_SETUP           ; send first setup command byte 
            plo     rd                  ; put in rd.0 to send byte directly
            call    lcd_send_byte   ; send setup byte to display 
            lbdf    err_exit            ; if error, exit immediately
            
            load    rc, DELAY_5MS       ; wait at least 5 milliseconds
            call    util_delay
            
            
            ldi     LCD_SETUP           ; send second setup command
            plo     rd                  ; put in rd.0 to send byte directly
            call    lcd_send_byte   ; send setup byte to display 
            lbdf    err_exit            ; if error, exit immediately
            
            load    rc, DELAY_5MS       ; wait at least 5 milliseconds
            call    util_delay
            
            ldi     LCD_SETUP           ; send third setup command
            plo     rd                  ; put in rd.0 to send byte directly
            call    lcd_send_byte   ; send setup byte to display 
            lbdf    err_exit            ; if error, exit immediately
            
            load    rc, DELAY_200uS     ; wait at least 200 microseconds
            call    util_delay
            
            ldi     LCD_4BIT            ; send 4-bit display command
            plo     rd                  ; put in rd.0 to send byte directly
            call    lcd_send_byte   ; send 4-bit display byte to display 

err_exit:   pop     rc
            pop     rd
            return              

reset_cmd:  db      $00                 ; set backlight, RS and R/W bits low           
            endp
