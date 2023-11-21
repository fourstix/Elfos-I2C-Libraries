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
; This routine has the BlinkM Smart Led to stop playing the current
; light script. The BlinkM device's current address is defined in the 
; blinkm_def.inc file above
;    
; Example: 
;   The following instructs the BlinkM Smart LED to stop playing the current script 
;            call   blinkm_stop_s      ; stop playing the current light script
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    blinkm_stop_s
            
            call    i2c_wrbuf          ; write to blinkm device
            db      I2C_ADDR , $01     ;    where i2c addr = $09  for 4 bytes
            dw      blinkms            ; message buffer
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
blinkms:    db    'o'                  ; stop current playing light script

            endp
            