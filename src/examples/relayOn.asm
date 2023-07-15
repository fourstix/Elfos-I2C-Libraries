;-------------------------------------------------------------------------------
; relayOn - a demo program to turn on a Sparkfun Qwiic  
; single relay with I2C using the PIO Expansion Board for the 
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

main:       lda     ra                  ; move past any spaces
            smi     ' '
            lbz     main
            dec     ra                  ; move back to non-space character
            ldn     ra                  ; get byte
            lbnz    usage               ; jump if any argument given
                        
            call    i2c_init            ; initialize i2c bus
            
            call    relay_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    relay_set_on        ; set relay on
            lbdf    errmsg              ; if can't turn on, show error msg
                                   
            return                      ;  return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: relayOn',10,13,0
            return                      ; and return to os

            end     start
