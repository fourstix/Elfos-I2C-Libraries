;-------------------------------------------------------------------------------
; memtest - a demo program to test an I2C memory device on the I2C bus
; like an Adafruit Non-Volatile Fram Breakout board or a Sparkfun Qwiic
; EEPROM Break board with I2C using the PIO Expansion Board and I2C adaptor
; for the 1802/Mini Computer.
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
#include ../include/mem_lib.inc
#include ../include/i2c_lib.inc


            org     2000h
start:      br      main


            ; Build information

            ever

            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument
main:       lda     ra                  ; check for any options
            smi     ' '                 ; move past any spaces
            lbz     main
            dec     ra                  ; move back to non-space character
            ldn     ra                  ; peek at byte
            lbz     def_test            ; if no argument use default address
          
            ldn     ra                  ; peek to see argument is valid hex digit
            call    f_ishex             ; DF=1 means valid hex, DF=0 means non-hex
            lbnf    usage               ; show usage message for non-hex argument
            
            ;----- process argument as test address on command line
            copy    ra, rf              ; copy argument address to rf
            call    f_hexin             ; convert input to hexadecimal value
            lbr     mem_test            ; rd has test address
            
                       

def_test:   load    rd, 0               ; set default test address 0000 

mem_test:   call    i2c_init            ; initialize i2c bus

            call    mem_avail           ; check i2c bus for device
            lbdf    no_id               ; exit with error msg, if not found
            
            copy    rd, r7              ; save copy of test address in r7
            
            load    rf, test_str        ; point rf to byte buffer
            ldi     21                  ; set test string size
            plo     rc
            call    mem_write_data      ; write the test string to device            
            lbdf    wr_err              ; if write error, exit with msg
            
            load    rf, dev_str         ; point rf to read buffer
            ldi     21                  ; set test string size
            plo     rc
            copy    r7, rd              ; restore test address from r7 

            call    mem_read_data       ; read the test data
            lbdf    rd_err              ; if write error, exit with msg
                          
            load    rf, test_str        ; compare test string to 
            load    rd, dev_str         ; string read from device
            call    f_strcmp
            lbnz    tst_fail            ; if strings don't match, fail test   

            call    o_inmsg             ; Strings matched, print success msg
            db      "Test passed.",10,13,0
            return                      ; return to Elf/OS
                        
tst_fail:   call    o_inmsg   
            db      'Test failed.',10,13,0
            abend                       ; return to Elf/os with error code
                      
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

wr_err:     call    o_inmsg   
            db      'Error writing to device.',10,13,0
            abend                       ; return to Elf/os with error code

rd_err:     call    o_inmsg   
            db      'Error reading device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: memtest [hhhh]',10,13
            db      '  Write a string to the device memory, read it back and verify match.',10,13
            db      '  The option hhhh is the test address in hex (default = 0000)',10,13,0

            return                      ; and return to os

test_str:   db      '1802 Cosmac Elf/os',10,13,0
dev_str:    db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
            end     start
