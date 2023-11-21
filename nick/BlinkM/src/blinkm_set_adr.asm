;-------------------------------------------------------------------------------
; blinkm_set_adr - a function to change the current / default i2c address of $09
; value to a user supplied #. Assumes BlinkM on I2C using the PIO and I2C    
; Expansion Boards for the 1802/Mini Computer.
;
; Copyright 2023 Milton 'Nick' DeNicholas
;
; This is an extension of Copyrighted work by Gaston Williams
; please see https://github.com/fourstix/Elfos-I2C-Libraries for more info
;
; Based on the the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
;-------------------------------------------------------------------------------

#include ../../include/ops.inc
#include ../../include/bios.inc
#include ../../include/kernel.inc
#include ../../include/sysconfig.inc
#include ../../include/i2c_lib.inc
#include ../../include/blinkm_def.inc

;-------------------------------------------------------------------------------
; This routine has the BlinkM Smart Led replace the current i2c address value
; with a user supplied address value. The BlinkM device's current address is 
; defined in the blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart replace the current i2c_addr 
;            call   blinkm_set_adr     ; set device i2c address
;            db     $13                ;   to new address of 0x13
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_set_adr
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd

            mov     r8, blinkmsa+1     ; point to where the New ADDR values go in the i2c cmd
            lda     r6                 ; get the new addr from call params
            str     r8                 ; save in the cmd buffer
            inc     r8                 ; bump to next place in cmd buffer
            inc     r8 
            inc     r8                 ;     to store the new addr
            str     r8                 ; save new addr in the cmd buffer
                        
            call    i2c_wrbuf          ; write to blinkm device
            db      I2C_ADDR , $05     ;    where i2c addr = I2C_ADDR for 5 bytes
            dw      blinkmsa           ; message buffer
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
blinkmsa:    db    'A',$13,$D0,$0D,$13 ; new i2c addr message

            endp
            