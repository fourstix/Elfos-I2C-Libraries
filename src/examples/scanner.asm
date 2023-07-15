;-------------------------------------------------------------------------------
; scanner - a demo program to scan the I2C bus for devices   
; using the PIO Expansion Board with the I2C Adaptor for the 
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
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
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
             
            phi     rc                  ; set up count of devices found
            phi     rf                  ; set up id register
            phi     rd                  ; clear index register
            plo     rd

            ldi     $02                 ; set up first id (00 and 01 are never id's)
            plo     rf

            ldi     $7E                 ; set up count of possible id's (126) 
            plo     rc                  ; possible id range is $02 to $7F
  
            
chk_id:     call    i2c_scan            ; check i2c bus for device
            lbdf    no_id               ; if not found, keep going

            glo     rf                  ; get id byte from register
            plo     rd                  ; put in index register for conversion
            plo     r7                  ; save current id in R7.0 
                          
            load    rf, id_hex          ; convert pressed byte to hex string
            call    f_hexout2
                          
            call    o_inmsg             ; print device found msg with id
            db      'Device found at $',0
            
            load    rf, id_hex
            call    o_msg

            call    o_inmsg             ; print eol
                    db 10,13,0      
            
            ghi     rc                  ; get device count
            adi     $01                 ; increment by one for device found
            phi     rc                  ; save updated count in rc.1

            
            glo     r7                  ; get saved id
            plo     rf                  ; put id back in register 
            
no_id:      inc     rf                  ; advance to next possible device id
            dec     rc                  ; count down number of possible id's
            glo     rc                  ; check counter
            lbnz    chk_id              ; keep checking for all possible id's
                                      
            ldi     0                   ; set up rd with device count
            phi     rd                  ; clear out upper byte
            ghi     rc                  ; get device count
            plo     rd                  ; and put into rd.0
            
            load    rf, count_buf       ; no need to save rf since done with id's  
            call    f_intout            ; convert rd to integer string

            call    o_inmsg             ; print prompt for count
                    db 'Devices found: ' ,0      
            
            load    rf, count_buf
            call    o_msg               ; print count string in buffer
            
            call    o_inmsg             ; print eol
                    db 10,13,0      
            
            
done:       ldi     0
            return                      ; return to Elf/OS
          

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: scanner',10,13,0
            call    o_inmsg
            db      'Scan the I2C bus for devices.',10,13,0
            abend                       ; and return to os with error code

id_hex:     db 0,0,0                    ; buffer for id hex string
count_buf:  db 0,0,0,0,0,0,0            ; buffer for device count
            end     start
