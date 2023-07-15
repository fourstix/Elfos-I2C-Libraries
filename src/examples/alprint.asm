;-------------------------------------------------------------------------------
; alprint - a demo program for displaying a string on an Sparkfun 4 character 
; 14-segment alphanumeric display with I2C using the PIO Expansion Board for the 
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
            lbz     usage               ; jump if no argument given
            
            LOAD    rd, chars           ; buffer pointer for chars
            ldi     4                   ; 4 chars in display
            plo     rc                  ; set char count
            
next_char:  lda     ra                  ; get char
            lbz     show_it             ; if we get a null, we're done
            str     rd                  ; store in buffer
            inc     rd                  ; move to next position
            dec     rc                  ; count down
            glo     rc                  ; check digit count
            lbnz    next_char           ; keep going until up to four chars read
            
show_it:    call    i2c_init            ; initialize i2c bus

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

            LOAD    rf, chars           ; set up pointer to character buffer
            ldi     4                   ; 4 positions on display
            plo     rc                  ; set RC to position counter
            ldi     0                   ; set characters position
            plo     ra                  ; to first character in display

get_char:   lda     rf                  ; get the char value
            plo     rb                  ; write character to display buffer 

            CALL    alnum_write_char

            inc     ra                  ; move location to next position

            dec     rc                  ; count down
            glo     rc                  ; check count
            lbnz    get_char            ; keep going to fill display
            
            ;---- update display
done:       CALL    alnum_write_disp
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     0
            return                      ; return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

usage:     call    o_inmsg              ; otherwise display usage message
            db      'Usage: alprint aaaa, where a is an ASCII character',10,13,0
            abend                       ; and return to os
            
chars:      db $20, $20, $20, $20       ; four spaces (blanks)      

            end     start
