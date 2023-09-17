;-------------------------------------------------------------------------------
; twist - a demo program to read information from a Sparkfun   
; Qwiic Twist RGB Rotary Encoder with I2C using the PIO and I2C 
; Expansion Boards for the 1802/Mini Computer.
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
; Sparkfun Qwiic Twist RGB Rotary Encoder hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15083 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/twist_lib.inc
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
            
            call    twist_avail         ; check i2c bus for joystick
            lbdf    no_id               ; exit with error msg, if not found

            ldi     0                   ; set up color offset
            plo     rb
            
            call    twist_get_version   ; rf points to version string
            lbdf    errmsg

            call    o_inmsg             ; print firmware label
            db 'Twist ',0

            call    o_msg               ; print version string in rf

            call    prt_eol 
            
            load    rd, clr_table       ; point to base color
            call    twist_set_color     ; turn off color
            
            load    rd, 12              ; set red to increase when turned right
            call    twist_chg_red 

            load    rd, 0               ; don't change green
            call    twist_chg_green
            
            load    rd, -12             ; set blue to decrease when turned right
            call    twist_chg_blue            
            
loop:       call    twist_get_status    ; check the status byte
            lbdf    errmsg              ; print msg if failed
            lbz     no_chg              ; don't print info if unchanged
            
            plo     r7                  ; save byte for bit testing
                        
            ani     TWIST_MOVED         ; test if encoder moved
            lbz     chk_btn             ; if not moved check button
            
            ; get the count
            call    twist_get_count
            lbdf    errmsg
          
            load    rf, int_buf         ; convert count to integer string
            call    f_intout
                      
            load    rf, int_buf         ; print count value
            call    o_msg

            call    prt_eol             ; print eol
            
chk_btn:    glo     r7                  ; check if button has been pressed
            ani     TWIST_PRESSED
            lbz     no_chg
            
            load    rd, $0000           ; reset count
            call    twist_set_count
            
            inc     rb                  ; update color index
            glo     rb                  ; check for overflow
            smi     6                   ; DF = 0 means D < 6
            lbnf    chg_clr             ; 0 to 5 is OK, so go ahead
            ldi     0                   ; DF = 1, D >= 6, so roll over to zero
            plo     rb
            
chg_clr:    glo     rb                  ; get index
            shl                         ; multiply index by four
            shl                         ; by shifting twice
            str     r2                  ; put 4*index in M(X)
            glo     rb                  ; get index again and subtract
            sd                          ; M(X) - D = (4*index - index) = 3*index
            str     r2                  ; save offset in M(X)
            
            load    rd, clr_table       ; point to base of color table

            glo     rd                  ; add offset to lower byte of pointer
            add                         ; D = D + M(X)
            plo     rd                  ; save value in buffer register
            ghi     rd                  ; add carry flag into high byte
            adci    0
            phi     rd                  ;rd now points to the new rgb color value
            
            call    twist_set_color     ; change button color  
            lbdf    errmsg
                         
no_chg:     load    rc, DELAY_500MS     ; wait half a second for input
            call    util_wait
            lbdf    done                ; exit if input pressed
            lbr     loop                ; repeat readings until input pressed
            
            
done:       load    rd, clr_table       ; turn off color before exiting
            call    twist_set_color     
            lbdf    errmsg

            ldi     0
            return                      ; return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: twist',10,13,0
            abend                       ; and return to os with error code

prt_eol:    call    o_inmsg             ; print eol
            db      10,13,0      
            return

int_buf:    db 0,0,0,0,0,0,0,0          ; buffer for count int string            

clr_table:  db 0,0,0                    ; initial color is black (off)
gold:       db 255,215,0
slate:      db 12,128,144
orchid:     db 153,50,204
aqua:       db 32,178,170
kelly:      db 0,128,0

            end     start
