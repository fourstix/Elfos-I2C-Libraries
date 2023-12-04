;-------------------------------------------------------------------------------
; bichar - a demo program for an Adafruit Bicolor 8x8 LED matrix 
; display with I2C using the PIO and I2C Expansion Boards for the 
; 1802/Mini Computer.
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2022 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Based on code from Adafruit_GFX library
; Written by Limor Fried/Ladyada for Adafruit Industries  
; Copyright 2012 by Adafruit Industries
; Please see https://learn.adafruit.com/adafruit-gfx-graphics-library for more info
;
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/util_lib.inc
#include ../include/mtrx_lib.inc
#include ../include/gfx_lib.inc
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

            call    mtrx_avail          ; check for display
            lbdf    no_id               ; if not found, exit program
            
            call    mtrx_init           ; set up display
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    mtrx_blink_off      ; turn off blinking
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    mtrx_brightness     ; set brightness
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     1                   ; set orign to 1,0
            plo     r7                  ; set x origin
            ldi     0
            phi     r7                  ; set y origin

            ldi     0                   ; set up counter 
            plo     rc
            phi     rc        
            

            ldi     LED_RED           
            phi     r9                  ; set pixel color

loop:       glo     rc                  ; get counter from index
            smi     96                  ; check for end
            lbdf    done                ; if we reached the end, exit
            
            glo     rc                  ; get offset
            str     r2                  ; save in M(X)

            ldi    ' '                  ; printable chars start at space
            add                         ; convert to character
            plo    r9                   ; save char to write

            call    mtrx_clear          ; clear out display buffer

            push    r7                  ; r7 is consumed              
            call    gfx_draw_char       ; draw character bitmap
            pop     r7                  ; restore r7
                                  
            ;---- update display to show pixels
            call    mtrx_update          ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg

            push    rc                  ; save counter
            load    rc, DELAY_500MS     ; wait a bit before continuing
            call    util_wait
            pop     rc                  ; retore counter              
                      
            lbdf    break               ; exit without clearing display 
                            
            inc     rc
            lbr     loop                ; continue 
            
            ;---- exit and clear after all characters            
done:       call    mtrx_clear          
            call    mtrx_update         ; update display
      
            ;---- show last character if input pressed
break:      ldi     0
            return                      ; return to Elf/OS
            
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: bichar',10,13,0
            abend                       ; and return to os
            
            end     start
