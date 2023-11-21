;-------------------------------------------------------------------------------
; blinkm_play_s - a function to play 1 of 18 preprogrammed scripts in the
; BlinkM smart led. Assumes BlinkM on I2C using the PIO and I2C    
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
; This routine has the BlinkM Smart Led play 1 of 18 preprogranned light scripts
; stored in the device. The BlinkM device's current address is 
; defined in the blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart lED to play script #18 SOS 
;           call    blinkm_play_s      ; play light script #0 to 18
;           db      18                 ; play script #18  SOS
;           db      $5                 ; number of times to repeat script
;           db      $0                 ; start at the begining 
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_play_s
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd

            mov     r8, blinkmp+1      ; point to where the play script params go in the i2c cmd
            lda     r6                 ; get which script to play from call params
            str     r8                 ; save in the cmd buffer
            inc     r8                 ; bump to repeat param
            lda     r6                 ; get the repeat param from call params
            str     r8                 ; save  in the cmd buffer
            inc     r8                 ; bump to where in script to start
            lda     r6                 ; get the where start from call params,
                                       ; 0 = start playing from start line of script
            str     r8                 ; save  in the cmd buffer
                        
            call    i2c_wrbuf          ; write to blinkm device
            db      I2C_ADDR , $04     ;    where i2c addr = $09  for 4 bytes
            dw      blinkmp            ; message buffer
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
blinkmp:    db    'p',$01,$05,$00      ; Play Light Script #1, 5 times, from the start

            endp
            