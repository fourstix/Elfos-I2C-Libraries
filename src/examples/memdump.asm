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
            lbz     def_addr            ; if no argument use default address
          
            ldn     ra                  ; peek to see argument is valid hex digit
            call    f_ishex             ; DF=1 means valid hex, DF=0 means non-hex
            lbnf    usage               ; show usage message for non-hex argument
            
            ;----- process argument as test address on command line
            copy    ra, rf              ; copy argument address to rf
            call    f_hexin             ; convert input to hexadecimal value
            lbr     mem_dump            ; rd has test address
            
                       

def_addr:   load    rd, 0               ; set default test address 0000 

mem_dump:   call    i2c_init            ; initialize i2c bus

            call    mem_avail           ; check i2c bus for device
            lbdf    no_id               ; exit with error msg, if not found
            
            copy    rd, ra              ; save copy of address in ra
            
            load    rf, test_buf        ; point rf to byte buffer
            ldi     128                 ; set buffer size
            plo     rc
            call    mem_read_data       ; write the test string to device            
            lbdf    rd_err              ; if read error, exit with msg
            
            
            load   r7, test_buf         ; set r7 to data buffer
            
            ;---------------- adapted from minimon ----------------                         
            ; Registers Used:
            ;   RC.0  - count of display lines
            ;   RB - count of displayed bytes
            ;   RA - device address
            ;   R7 - buffer address for hex values
            ;   R8 - buffer address for characters
            ;------------------------------------------------------                         


            ldi     8                   ; set count to 128 bytes
            plo     rc
exloop1:    ghi     ra                  ; get address
            phi     rd                  ; transfer for output
            glo     ra
            plo     rd
            load    rf, line_buf        ; point rf to  line buffer
           
            call    f_hexout4
            ldi     ':'                 ; want a colon after device address
            str     rf
            inc     rf
            ldi     16                  ; 16 bytes per line
            plo     rb                  ; put into secondary counter
            copy    r7, r8              ; make a copy of the address
            
exloop2:    ldi     ' '                 ; output a space
            str     rf
            inc     rf
            lda     r7                  ; get next byte from buffer
            plo     rd                  ; prepare for output
            call    f_hexout2
            dec     rb                  ; decrement line count
            glo     rb                  ; get count
            lbnz    exloop2             ; loop back if not done
            
            ldi     ' '                 ; add two extra spaces
            str     rf
            inc     rf
            str     rf
            inc     rf
            ldi     16                  ; set count
            plo     rb
            
advlp:      ldn     r8                  ; get next byte
            smi     32                  ; check for < space
            lbnf    advdot              ; jump if not displayable
            
            ldn     r8                  ; recover byte
            smi     127                 ; check for printable range
            lbdf    advdot              ; jump if not displayable
            
            ldn     r8                  ; recover byte
            str     rf                  ; store into buffer
            inc     rf
            lbr     advgo               ; then continue

advdot:     ldi     '.'                 ; add a dot
            str     rf
            inc     rf

advgo:      inc     r8                  ; point to next address
            dec     rb                  ; decrement count
            glo     rb                  ; check count
            lbnz    advlp               ; loop back if not done

            ldi     0                   ; need terminator for string
            str     rf
            
            load    rf, line_buf        ; point rf to line buffer
            call    o_msg               ; output the line
          
            call    o_inmsg             ; move to next line
            db      10,13,0
            
            add16   ra, 16              ; adjust device address for next line
            dec     rc                  ; decrement line count
            glo     rc                  ; get count
            lbnz    exloop1             ; loop back if not all lines printed

            ;---------------- adapted from minimon                          
            call    o_inmsg             ; Strings matched, print success msg
            db      "Ok.",10,13,0
            return                      ; return to Elf/OS
                                               
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

rd_err:     call    o_inmsg   
            db      'Error reading device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: memdump [hhhh]',10,13
            db      '  Show the contents of a 128 byte block in the device memory',10,13
            db      '  where hhhh is optional block address in hex (default = 0000)',10,13,0

            return                      ; and return to os
line_buf:   ds      72
test_buf:   ds      128
            end     start
