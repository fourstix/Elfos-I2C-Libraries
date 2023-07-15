;-------------------------------------------------------------------------------
; alclear - a demo program to blank out a Sparkfun 4 character 14-segment 
; alphanumeric display with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
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
            lbnz    usage               ; jump if any argument given
                        
show_it:    call    i2c_init            ; initialize i2c bus

            call    alnum_avail         ; check for device
            lbdf    no_id               ; if not found, exit program

            call    alnum_init          ; initialize device
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    alnum_set_blink_off ; turn off blinking
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    alnum_set_brightness
            lbdf    errmsg              ; if error writing to device, exit with msg

            ;---- update display
            call    alnum_write_disp
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     0
            return                      ; return to Elf/OS
            
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: alclear',10,13,0
            abend                       ; and return to os
            
            end     start
