;-------------------------------------------------------------------------------
; mem_read_data - a routine to read data from an I2C memory device
; like an Adafruit Non-Volatile Fram Breakout board or a Sparkfun 
; Qwiic EEPROM Break board with I2C using the PIO Expansion Board
; and I2C adaptor for the 1802/Mini Computer.
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
; This routine reads data from address in the device.
; Parameters:
;   RC.0 = count of bytes to read
;   RD = address to read data from
;   RF = pointer to data buffer
; Returns: 
;   DF = 0 on success, DF = 1 on error
;   RD points to next address after read
;   RF points to one past last byte read
;-------------------------------------------------------------------------------

            proc    mem_read_data
              
rd_byte:    glo     rc                  ; check to see if more data to read
            lbz     rd_done             ; if not, we're done            
                            
            call    i2c_rdaddr          ; send command to read a byte into D
            db      I2C_ADDR
            lbdf    err_exit            ; DF=1 means an error occurred
            
            str     rf                  ; put data byte into buffer
            inc     rf                  ; move buffer pointer to next location
            inc     rd                  ; move address pointer to next address
            dec     rc                  ; count down bytes
            lbr     rd_byte             ; keep going until all bytes read 
            
rd_done:    CLC                         ; make sure DF = 0           
err_exit:   return

            endp
            
