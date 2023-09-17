;-------------------------------------------------------------------------------
; keypad - a demo program to read information from a Sparkfun   
; Qwiic 12 Button Keypad with I2C using the PIO and I2C 
; Expansion Boards for the 1802/Mini Computer.
;
; Copyright 2023 by Gaston Williams
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Sparkfun Qwiic 12 Button Keypad hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15290 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/keypad_lib.inc
#include ../include/i2c_lib.inc
#include ../include/util_lib.inc


            org     2000h
start:      br      main


            ; Build information

            ever

            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument

main:       lda     ra                  ; move past any spaces
            smi     ' '
            lbz     main
            dec     ra                  ; move back to non-space character
            ldn     ra                  ; get byte
            lbnz    usage               ; jump if any argument given
                        
            call    i2c_init            ; initialize i2c bus
            
            call    keypad_avail        ; check i2c bus for joystick
            lbdf    no_id               ; exit with error msg, if not found

            call    keypad_get_version  ; rf points to version string
            lbdf    errmsg

            call    o_inmsg             ; print firmware label
            db      'Keypad ',0

            call    o_msg               ; print version string in rf

            call    o_inmsg             ; print eol
            db      10,13,0      
            
loop:       call    keypad_read_key     ; update and read key press
            lbdf    errmsg              ; print msg if failed
            lbz     no_key              ; 0 means no key available
            
            call    f_tty               ; print the key value 
  
no_key:     load    rc, DELAY_200MS     ; wait a bit for input
            call    util_wait
            lbdf    done                ; exit if input pressed
            lbr     loop                ; repeat readings until input pressed
            
done:       ldi     0
            return                      ; return to Elf/OS
                      

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: keypad',10,13,0
            abend                       ; and return to os with error code

            end     start
