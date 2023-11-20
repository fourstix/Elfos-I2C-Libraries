;-------------------------------------------------------------------------------
; tsl2561_set_tng - a function to set gran and integration timing for the
; TSL2561 LUX Sensor with I2C using the PIO and I2C Expansion Boards for 
; the 1802/Mini Computer.
;
; Sensor details see ==> https://learn.adafruit.com/tsl2561?view=all
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
#include ../../include/tsl2561_def.inc

;-------------------------------------------------------------------------------
; This routine gain and timing of the TSL2561 and configures the i2c device whose
; address is defined in the tsl2561_def.inc file above
;
; Example: 
;   The following instructs the TSL2561 to set the gain and integration timing
;           call    tsl2561_set_tng    ; set timing and gain params
;           db      TSL2561_GAIN_16X+TSL2561_INTEGRATIONTIME_402MS  ; user provided params
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    tsl2561_set_tng    ; Set the Integration Timing and Gain and Manual start stop
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd            

            mov     r8, tim_gan        ; point to timing, gain, manual control byte
            lda     r6                 ; get byte from call params
            str     r8                 ; save in the cmd buffer
            call    i2c_wrbuf          ; write to tsl2561 device
            db      I2C_ADDR , $02     ;    where i2c addr = I2C_ADDR for 2 bytes
            dw      tng_msg            ; message buffer
            return
                        
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
tng_msg:    db    TSL2561_COMMAND_BIT+TSL2561_REGISTER_TIMING   ; tsl2561 command code 
tim_gan:    db    TSL2561_GAIN_1X+TSL2561_INTEGRATIONTIME_13MS  ; Timing/Gain Control/Integrate Start/Stop

            
            endp
            