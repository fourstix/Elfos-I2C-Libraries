;-------------------------------------------------------------------------------
; tsl2561_read_c0 - a function to read the visible light+IR = full spectrum sensed  
; by the TSL2561 LUX Sensor with I2C using the PIO and I2C Expansion Boards for 
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
; This routine reads the TSL2561 16 bit output of the visible light A/D and the
; IR light sensed by the i2c device whose address is defined in the
; tsl2561_def.inc file above
;
; Example: 
;   The following instructs the TSL2561 to read the full spectrum value sensed
;           call    tsl2561_read_c0    ; read sensor value of Visible & IR
;           dw      lux_read           ; address of where the result goes
;                                      ; the results are low byte first then
;                                      ; high byte
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    tsl2561_read_c0    ; Read Visible and IR channel
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd            
            
            mov     r8, read_dest      ; point to read buffer address
            lda     r6                 ; get addr.1 from call params
            str     r8                 ; save in the cmd buffer
            inc     r8
            lda     r6                 ; get addr.0 from call params
            str     r8                 ;
            call    i2c_rdreg          ; read from tsl2561 device register
            db      I2C_ADDR           ;   where i2c addr = I2C_ADDR
            db      $01                ;     length of Reg ID
            db      TSL2561_COMMAND_BIT+TSL2561_REGISTER_CHAN0_LOW+TSL2561_WORD_BIT  ; Register ID
            db      $02                ;           read 2 bytes
read_dest:  dw      $0000              ; read message buffer, A/D low byte, A/D then high byte
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
            
            return                     ;   DF = 0 on success, DF = 1 on error             
            
            endp
            