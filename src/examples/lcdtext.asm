;-------------------------------------------------------------------------------
; lcdtext - a demo program for changing the text direction on a 
; Liquid Crystal Display with I2C using the PIO and I2C Expansion Boards
; for the 1802/Mini Computer.
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
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/lcd_lib.inc
#include ../include/util_lib.inc
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
                        
            call    i2c_init            ; initialize i2c bus
            
            call    lcd_avail           ; check i2c bus for display
            lbdf    no_id               ; exit with error msg, if not found

            call    lcd_init            ; initialize display
            lbdf    errmsg

            call    lcd_cursor_on       ; turn cursor on for demo
            lbdf    errmsg

            load    rf, prompt          ; print input prompt message
            call    o_msg
            
            ; print a message on the display
begin_demo: ldi     'a'                 ; set up initial character in r7
            plo     r7                  ; put character in r7
            
loop1:      glo     r7
            call    lcd_print_char      ; print the character to display
            
            inc     r7                  ; go to next character
            
            load    rc, DELAY_500MS     ; wait a bit between characters
            call    util_wait
            lbdf    end_demo            ; if input is pressed, end demo

            glo     r7                  ; check if we reached 'm'
            smi     'm'                 
            lbnz    check_s 
            call    lcd_right_to_left   ; change text direction
            lbr     loop1               ; continue printing characters   

check_s:    glo     r7                  ; check if we reached 's'
            smi     's'                 
            lbnz    check_end 
            call    lcd_left_to_right   ; change text direction back
            lbr     loop1               ; continue demo until past z
            
check_end:  glo     r7                  ; get the character
            smi     'z'+1               ; check for one past z
            lbnf    loop1               ; if we haven't passed z, continue
                        
            load    rc, DELAY_500MS     ; wait a bit between characters
            call    util_wait
            lbdf    end_demo            ; if input is pressed, end demo
            
            load    rc, DELAY_500MS     ; wait a bit between characters
            call    util_wait
            lbdf    end_demo            ; if input is pressed, end demo
            
            call    lcd_clear           ; clear display for next round
            lbdf    errmsg
            
            call    lcd_home            ; home cursor for next round
            lbdf    errmsg
                
            lbr     begin_demo          ; repeat demo  

end_demo:   call    lcd_display_off     ; turn off display
            lbdf    errmsg
            
            call    lcd_backlight_off   ; turn off backlight
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
            db      'Usage: lcdtext',10,13,0
            abend                       ; and return to os with error code

prompt:     db      'Press Input to end the demo.',10,13,0

            end     start
