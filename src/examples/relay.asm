;-------------------------------------------------------------------------------
; relay - a demo program to read the state of a Sparkfun Qwiic  
; single relay with I2C using the PIO Expansion Board for the 
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
;
; Sparkfun Qwiic Single Relay
; Copyright 2019-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/products/15093 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/relay_lib.inc
#include ../include/i2c_lib.inc


            org     2000h
start:      br      main


            ; Build information

            ever

            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument
        
main:       lda     ra                  ; check for any options
            smi     ' '                 ; move past any spaces
            lbz     main
            dec     ra                  ; move back to non-space character
            lda     ra                  ; get byte
            lbz     rly_state           ; if no argument do default
            smi     '-'                 ; check for dash 
            lbnz    usage               ; anything but dash is an error
            lda     ra                  ; get next option
            smi     's'                 ; check for state option
            lbz     rly_state
            lbnf    usage               ; anything less than an s, is an error
            smi     1                   ; check for toggle option 't'-'s' = 1
            lbz     rly_toggle          ; t means toggle
            smi     2                   ; check for version
            lbz     rly_vers            ; v means version
            lbr     usage               ; anything else, is an error


rly_toggle: call    i2c_init            ; initialize i2c bus

            call    relay_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found
            
            call    relay_get_state     ; get the state of relay (OFF or ON)
            lbdf    errmsg              ; exit with error msg, if unable to get relay state            
            lbnz    relay_off           ; if on, turn it off
            
            call    relay_set_on        ; if off, turn it on
            lbr     on_msg              ; and show message
            
relay_off:  call    relay_set_off
            lbr     off_msg

rly_vers:   call    i2c_init            ; initialize i2c bus

            call    relay_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    relay_get_version   ; set rf to firmware version
            lbdf    errmsg              ; if cannot get version, exit with msg

            call    o_msg               ; print version string in rf

            call    o_inmsg             ; print eol
            db      10,13,0
            return                      ; return to Elf/OS
                        
                      
rly_state:  call    i2c_init            ; initialize i2c bus
            call    relay_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    relay_get_state     ; get the state of relay (OFF or ON)                              
            lbdf    errmsg             ; DF=1 means an error occurred
            lbnz    on_msg

off_msg:    call    o_inmsg
            db      'Relay is OFF',10,13,0
            return 
              
on_msg:     call    o_inmsg
            db      'Relay is ON',10,13,0                              
            return                      ;  return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: relay (-s|-t|-v)',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      'Options: -s Show relay state (default)',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      ' -t Toggle relay',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      ' -v Show relay firmware version',10,13,0                        
            return                      ; and return to os

            end     start
