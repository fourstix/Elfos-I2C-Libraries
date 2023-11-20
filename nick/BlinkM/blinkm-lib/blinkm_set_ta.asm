;-------------------------------------------------------------------------------
; blinkm_set_ta - a function to set a playback speed time adjustment
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
; This routine has the BlinkM Smart Led set the time adjust value with a user 
; supplied time adjust value. The BlinkM device's current address is 
; defined in the blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart to set a time adjustment value 
;           call   blinkm_set_ta       ; set play script speed adjustment
;           db     $05                 ; -127 to -1 slower, +1 to 127 faster
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_set_ta
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd

            mov     r8, blinkmta+1     ; point to time adjust value in the i2c cmd
            lda     r6                 ; get the time adjust value from call params
            str     r8                 ; save in the cmd buffer
            call    i2c_wrbuf          ; write to blinkm device
            db      I2C_ADDR , $02     ;    where i2c addr = $09  for 4 bytes
            dw      blinkmta           ; message buffer

            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
blinkmta:   db    't',$00              ; set the fade speed (faster -128 to -255) to slower(1 to 127))

            endp
            