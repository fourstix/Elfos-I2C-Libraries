;-------------------------------------------------------------------------------
; led7print - a demo program for displaying a string on an Adafruit 4 digit 
; 7-segment display with I2C using the PIO Expansion Board for the 
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
; Adafruit 4 Digit 7-Segment Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/led7_lib.inc
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
            lbz     usage               ; show msg if no argument given
            
            LOAD    rd, digits          ; buffer pointer for digits
            ldi     4                   ; 4 digits in display
            plo     rc                  ; set digit count
            
next_dgt:   lda     ra                  ; get digit
            call    f_ishex             ; check for valid digit 
            lbnf    non_hex             ; if non-hex char, check for decimal or colon
            plo     re                  ; save character for testing
            smi     '0'                 ; calculate offset for '0-9'
            plo     rf                  ; save offset
            smi     10                  ; if less than 10, then valid digit
            lbnf    save_dgt  
            glo     re                  ; get character
            smi     'A'                 ; calculate offset for 'A-F'
            plo     rf                  ; save offset
            smi      6
            lbnf    fix_hex             ; if less than 6, then valid hex digit
            glo     re                  ; get character
            smi     'a'                 ; calculate offset for 'a-f'   
            skp                         ; already in D, so no need to save/restore 
fix_hex:    glo     rf                  ; get offset
            adi     10                  ; set offset so A-F is from 10 to 15
            skp                         ; value in D, so no need to save/restore
save_dgt:   glo     rf                  ; get offset
            str     rd                  ; store in buffer
            inc     rd                  ; move to next position
            dec     rc                  ; count down
            glo     rc                  ; check digit count
            lbnz    next_dgt            ; keep going until four digits read
            ldn     ra                  ; peek at character after 4th digit
                                        ; in case it's a decimal or colon
                                        
non_hex:    plo     re                  ; save character for tests
            smi     '.'                 ; check for decimal point
            lbz     decimal
            glo     re
            smi     ':'
            lbnz    show_it             ; any unexpected char truncates
            LOAD    rf, colon           ; point to colon flag
            ldi     $01                 ; set flag to true
            str     rf  
            lbr     chk_pos             ; continue with next character in string  

decimal:    glo     rc                  ; check position
            smi     4                   ; 4 is the initial position 
            lbz     lead_dp
            dec     rd                  ; back up pointer to previous position
lead_dp:    ldn     rd                  ; get value
            ori     $80                 ; set upper bit of high nibble as flag
            str     rd                  ; save updated value
            inc     rd                  ; move back to character position
chk_pos:    glo     rc                  ; check position again  
            lbnz    next_dgt            ; if not last position, keep going 
            
            
show_it:    call    i2c_init            ; initialize i2c bus

            call    led7_avail          ; check for display
            lbdf    no_id               ; if not found, exit program
            
            call    led7_init           ; set up display
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    led7_set_blink_off  ; turn off blinking
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    led7_set_brightness ; set brightness
            lbdf    errmsg              ; if error writing to device, exit with msg

            LOAD    rf, digits          ; set up pointer to digit buffer
            ldi     0                   ; set digit position
            plo     ra                  ; to first digit in display

            lda     rf                  ; get the digit value
            plo     rb                  ; set digit value in led7 buffer 
            ani     $10                 ; check blank flag
            lbz     digit1              ; if blank flag not set, write digit
            call    led7_write_blank               
            lbr     dp_1
digit1:     call    led7_write_digit
dp_1:       glo     rb
            ani     $80                 ; mask dp flag
            lbz     pos2                ; if no decimal flag, don't bother
            call    led7_write_dp
            
pos2:       inc     ra                  ; move to second digit position
            lda     rf                  ; get next digit value                  
            plo     rb                  ; set digit value in led7 buffer
            ani     $10                 ; check blank flag
            lbz     digit2              ; if blank flag not set, write digit
            call    led7_write_blank
            lbr     dp_2               
digit2:     call    led7_write_digit
dp_2:       glo     rb
            ani     $80                 ; mask dp flag
            lbz     pos3                ; if no decimal flag, don't bother
            call    led7_write_dp

pos3:       inc     ra                  ; move to third digit position
            lda     rf                  ; get next digit value                  
            plo     rb                  ; set digit value in led7 buffer
            ani     $10                 ; check blank flag
            lbz     digit3              ; if blank flag not set, write digit
            call    led7_write_blank               
            lbr     dp_3
digit3:     call    led7_write_digit
dp_3:       glo     rb
            ani     $80                 ; mask dp flag
            lbz     pos4                ; if no decimal flag, don't bother
            call    led7_write_dp

pos4:       inc     ra                  ; move to last digit position
            lda     rf                  ; get last digit value                  
            plo     rb                  ; set digit value in led7 buffer
            ani     $10                 ; check blank flag
            lbz     digit4              ; if blank flag not set, write digit
            call    led7_write_blank
            lbr     dp_4               
digit4:     call    led7_write_digit
dp_4:       glo     rb
            ani     $80                 ; mask dp flag
            lbz     chk_colon           ; if no decimal flag,  don't bother
            call    led7_write_dp

chk_colon:  LOAD    rf, colon           ; check colon flag
            ldn     rf
            lbz     done
            plo     rb
            call    led7_write_colon
            ;---- update display
done:       call    led7_write_disp     ; update display
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
            db      'Usage: led7print hhhh, where h is hexadecimal digit 0-F',10,13,0
            abend                       ; and return to os
            
digits:     db $10, $10, $10, $10       ; $10 is blank flag, $80 is decimal flag
colon:      db 0                        ; flag to turn colon off and on

            end     start
