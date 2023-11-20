;-------------------------------------------------------------------------------
; blinkm_get_rgb - a function to read and store the current RGB (Red, Green, Blue)
; values. Assumes BlinkM on I2C using the PIO and I2C Expansion   
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
; This routine has the BlinkM Smart Led return the current RGB (Red, Green, Blue)
; color. The BlinkM device's address is defined in the blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart get the current RGB color
;           call    blinkm_get_rgb     ; get current RGB values
;           dw      read_buff          ; and place them in this buffer
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_get_rgb
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd
            
            call    i2c_wrbuf          ; write request to blinkm device
            db      I2C_ADDR , $01     ;    where i2c addr = I2C_ADDR for 1 bytes
            dw      blinkmgc           ; message buffer
            
            mov     r8, rgb_store      ; point to where the storage area addr is
            lda     r6                 ; get high addr from passed params
            str     r8                 ; save into cmd buffer
            inc     r8                 ; get low addr from passed params
            lda     r6                 ; save into 
            str     r8                 ;     cmd buffer
            call    i2c_rdbuf          ; read from blinkm device
            db      I2C_ADDR , $03     ;    where i2c addr = I2C_ADDR for 3 bytes
rgb_store:  db      $00,$00            ;       into the storage area at this address            

            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
            
blinkmgc:    db    'g'                 ; request i2c current rgb values message

            endp
            