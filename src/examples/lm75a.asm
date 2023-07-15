;-------------------------------------------------------------------------------
; lm75a - a demo program to read the temperature from a   
; LM75A sensor with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
;
; Based on the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;-------------------------------------------------------------------------------

#include ../include/sysconfig.inc
#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/lm75a_lib.inc
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
            lbz     celsius             ; if no argument, do default
            smi     '-'                 ; check for dash 
            lbnz    usage             ; anything but dash is an error
            lda     ra                  ; get next option
            smi     'c'                 ; check for Celsius
            lbz     celsius
            smi     3                   ; 'f'-'c' = 3
            lbz     fahrenheit          ; check for Fahrenheit
            lbr     usage             ; anything else is an error


celsius:    call    i2c_init            ; initialize i2c bus

            call    lm75a_avail         ; check for device on i2c bus
            lbdf    no_id               ; show msg if not found
            
            call    lm75a_temperature_c ; read temperature in Celsius
            lbdf    errmsg              ; show msg, if read fails
            
            lbr     display

fahrenheit: call    i2c_init            ; initialize i2c bus
            call    lm75a_avail         ; check for device on i2c bus
            lbdf    no_id               ; show msg if not found

            call    lm75a_temperature_f ; read temperature in Fahrenheit
            lbdf    errmsg              ; show msg, if read fails
            
display:    call    o_msg               ; rf points to temperature string       

            ldi     0            
            return

no_id:
          #if I2C_GROUP
            sex     r3
            out     EXP_PORT            ; make sure default expander group
            db      NO_GROUP
            sex     r2
          #endif 

            call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     
          #if I2C_GROUP
            sex     r3
            out     EXP_PORT            ; make sure default expander group
            db      NO_GROUP
            sex     r2
          #endif 
          
            call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: lm75a (-c|-f)',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      'Options: -c Show temperature as Celsius (default)',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      '  -f Show temperature as Fahrenheit',10,13,0
            abend
            
            end     start
