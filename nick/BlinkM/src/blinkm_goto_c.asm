;-------------------------------------------------------------------------------
; blinkm_goto_c - a function to have the BlinkM Smart Led go to a specific 
; RGB (Red, Green, Blue). Assumes BlinkM on I2C using the PIO and I2C Expansion   
; Boards for the 1802/Mini Computer.
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
; This routine has the BlinkM Smart Led go to a specific RGB (Red, Green, Blue)
; color. The BlinkM device's address is defined in the blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart led to go to the passed RGB color
;           call    call    blinkm_goto_c   ; write to blinkm device go to color
;           db      C_GREY                  ; three bytes that define GREY R, G, B
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_goto_c
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd

            mov     r8, blinkmg+1      ; point to where the RGB values go in the i2c cmd
            lda     r6                 ; get the R color from call params
            str     r8                 ; save in the cmd buffer
            inc     r8                 ; bump to G color
            lda     r6                 ; get the G color from call params
            str     r8                 ; save  in the cmd buffer
            inc     r8                 ; bump to B color
            lda     r6                 ; get the B color from call params
            str     r8                 ; save  in the cmd buffer
                        
            call    i2c_wrbuf          ; write to blinkm device
            db      I2C_ADDR , $04     ;    where device addr = I2C_ADDR for 4 bytes
            dw      blinkmg            ; message buffer
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
            
blinkmg:    db    'n',$00,$00,$00      ; goto to R, G , B

            endp
            