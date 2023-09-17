;-------------------------------------------------------------------------------
; lcdscroll - a demo program for scrolling a Liquid Crystal Display with
; I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
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

            load    rf,prompt           ; print input prompt message
            call    o_msg
            
            ; print a message on the display
begin_demo: load    rf, test_msg
            call    lcd_print_str
            lbdf    errmsg

            ; scroll message left 13 positions
            ldi     13                  ; string length is 13 chars
            plo     r7                  ; use r7 as scroll count
loop1:      call    lcd_scroll_left     ; move entire display left
            lbdf    errmsg

            load    rc, DELAY_500MS     ; wait a bit between scrolling
            call    util_wait
            lbdf    end_demo            ; exit demo of input pressed
            
            dec     r7                  ; decrement scroll counter
            glo     r7
            lbnz    loop1               ; keep going until counter exhausted

            ; scroll message right 29 positions
            ldi     29                  ; string length is 13 chars
            plo     r7                  ; use r7 as scroll count
loop2:      call    lcd_scroll_right    ; move entire display left
            lbdf    errmsg

            load    rc, DELAY_500MS     ; wait a bit between scrolling
            call    util_wait
            lbdf    end_demo            ; exit demo of input pressed
            
            dec     r7                  ; decrement scroll counter
            glo     r7
            lbnz    loop2               ; keep going until counter exhausted

            ; scroll message back left 13 positions
            ldi     13                  ; string length is 13 chars
            plo     r7                  ; use r7 as scroll count
loop3:      call    lcd_scroll_left     ; move entire display left
            lbdf    errmsg
            
            load    rc, DELAY_500MS     ; wait a bit between scrolling
            call    util_wait
            lbdf    end_demo            ; exit demo of input pressed
            
            dec     r7                  ; decrement scroll counter
            glo     r7
            lbnz    loop3               ; keep going until counter exhausted
            
            load    rc, DELAY_500MS     ; wait a bit before restarting
            call    util_wait
            lbdf    end_demo            ; exit demo of input pressed

            load    rc, DELAY_500MS     ; wait a bit more before restarting
            call    util_wait
            lbdf    end_demo            ; exit demo of input pressed

            call    lcd_clear           ; clear display for next round
            lbdf    errmsg
            
            call    lcd_home            ; home cursor for next round
            lbdf    errmsg
                
            lbr     begin_demo          ; repeat demo  

end_demo:   call    lcd_display_off     ; turn off display
            lbdf    errmsg
            
            call    lcd_backlight_off   ; turn off backlight
            lbdf    errmsg
                                      
done:       ldi     0
            return                      ; return to Elf/OS

test_msg:   db 'Hello, World!',0        ; test message                      

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: lcdscroll',10,13,0
            call    o_inmsg             ; continue usage message
prompt:     db      'Press Input to end the demo.',10,13,0
            abend                       ; and return to os with error code

            end     start
