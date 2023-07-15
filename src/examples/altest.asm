;-------------------------------------------------------------------------------
; altest - a demo program to set segments abcd, the colon and decimal point on  
; a Sparkfun 4 character 14-segment alphanumeric display with I2C using the 
; PIO Expansion Board for the 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
;
; Based on the osclock program in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Sparkfun 4 Character 14-Segment Alphanumeric Display hardware
; Copyright 2019-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/categories/820 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/alnum_lib.inc
#include ../include/i2c_lib.inc


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
            lbnz    usage              ; jump if any argument given
                        
show_it:    call    i2c_init            ; initialize the i2c bus

            call    alnum_avail         ; check for device
            lbdf    no_id               ; if not found, exit program

            call    alnum_init
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    alnum_set_blink_off
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    alnum_set_brightness
            lbdf    errmsg              ; if error writing to device, exit with msg

            ;----   set byte for  position 0 segment a on
            ldi     0                   ; first position
            plo     ra                    
            ldi     0                   ; zero is segment a
            plo     rb                    
            call    alnum_write_segment ; turn segments on

            ;----   set byte for  position 1 segment b on
            inc     ra                  ; next position
            inc     rb                  ; next segment
            call    alnum_write_segment  

            ;----   set byte for  position 2 segment c on
            inc     ra                  ; next position
            inc     rb                  ; next segment
            call    alnum_write_segment  

            ;----   set byte for  position 3 segment d on
            inc     ra                  ; next position
            inc     rb                  ; next segment
            call    alnum_write_segment  

            ;----   set colon and decimal point on
            call    alnum_write_colon
            call    alnum_write_decimal

            ;---- update display
            call    alnum_write_disp
            lbdf    errmsg              ; if error writing to device, exit with msg

            ;----   print message for segments
            CALL    o_inmsg
            db      'Segments a,b,c,d',10,13,0
                      
            ldi     0
            return                      ; return to Elf/OS
            
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: altest',10,13,0
            abend                       ; and return to os
            
            end     start
