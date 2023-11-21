;-------------------------------------------------------------------------------
; lcdoff - demo to turn off a Liquid Crystal Display with I2C using 
; the PIO and I2C Expansion Boards for the 1802/Mini Computer.
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
            lda     ra                  ; get byte
            lbnz    usage               ; anything but null is an error
                      
begin:      call    i2c_init            ; initialize i2c bus
            
            call    lcd_avail           ; check i2c bus for display
            lbdf    no_id               ; exit with error msg, if not found

            call    lcd_display_off     ; turn off display
            lbdf    errmsg
            
            call    lcd_backlight_off   ; turn off backlight
            lbdf    errmsg
            
            call    lcd_init            ; initialize display
            lbdf    errmsg
                                      
done:       ldi     0
            return                      ; return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: lcdoff',10,13,0
            abend                       ; and return to os with error code

            end     start
