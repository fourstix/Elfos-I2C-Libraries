;-------------------------------------------------------------------------------
; mem_set_data - a routine to write data to a block of addresses in an 
; IC2 memory device like an Adafruit Non-Volatile Fram Breakout board or
; a Sparkfun Qwiic EEPROM Breakout board with I2C using the PIO Expansion
; Board and I2C adaptor for the 1802/Mini Computer.
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
; Adafruit Non-Volatile Fram Breakout Board
; Copyright 2014-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/1895 for more info
;
; Sparkfun Qwiic EEPROM Breakout Board
; Copyright 2018-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/products/18355 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/mem_lib.inc
#include ../include/util_lib.inc
#include ../include/mem_def.inc

;-------------------------------------------------------------------------------
; This routine writes data byte to a block addresses in the device.
; Parameters:
;   RC.0 = count of bytes to write
;   RD   = address to write data to
;   RF.0 = data byte to write
; Returns: 
;   DF = 0 on success, DF = 1 on error
;   RD points to next address after write
;   (RC.0 is consumed, RF.0 is preserved)
;-------------------------------------------------------------------------------

            proc    mem_set_data
            
set_byte:   glo     rc                  ; check to see if more data to read
            lbz     set_done            ; if not, we're done
            glo     rf                  ; get data byte
            
            call    i2c_wraddr          ; send command to write byte in D
            db      I2C_ADDR           
            lbdf    err_exit            ; DF=1 means an error occurred
            
            inc     rd                  ; move address pointer to next address
            dec     rc                  ; count down bytes
            lbr     set_byte            ; keep going until all bytes written  
            
set_done:   clc                         ; make sure DF = 0           
err_exit:   return

            endp
            
