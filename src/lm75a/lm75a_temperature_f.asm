;-------------------------------------------------------------------------------
; lm75a_temperature_f - a routine to read the temperature in Fahrenheit 
; using an LM75A sensor with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
;
; Based on the the Elf-I2C library
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
#include ../include/util_lib.inc
#include ../include/lm75a_def.inc

;-------------------------------------------------------------------------------
; This routine reads the temperature in degrees Fahrenheit
; Returns: 
;   RF = pointer to string with temperature in Fahrenheit
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    lm75a_temperature_f
            push    ra                  ; save data pointer
            push    rd                  ; save sum register

            call    i2c_rdreg
            db      I2C_ADDR
            db      1, TEMP_REG, 2      ; read 2 bytes from temperature register
            dw      temp_data
            lbdf    err_exit            ; if error, exit immediately

            mov     ra, temp_data       ; get temperature byte
            
            ldi     0
            phi     rd                  ; clear out upper byte of sum            
            phi     rf                  ; clear out upper byte of addend            


            lda     ra                  ; get the temperature byte
            plo     rd                  ; save in sum
            plo     rf                  ; save in addend
            ani     $80                 ; check sign bit
            lbz     sgn_pos             ; if positive, no need to sign extend                
            
            ldi     $FF                 ; sign extend negative values 
            phi     rd                  ; sign extend sum
            phi     rf                  ; sign extend addend
            
sgn_pos:    ldn     ra                  ; get byte with half-degree bit
            shl                         ; shift half-degree bit into DF
            call    util_c_to_f
            load    rf, temp_buf        ; point rf to buffer
            ldi     'F'                 ; set up Unit character
            call    util_write_10x      ; print temperature to buffer
                        
err_exit:   pop     rd                    ; restore rd
            pop     ra                    ; restore ra
            
            mov     rf, temp_buf          ; point rf to temperature string

            return

temp_data:  db      0, 0
temp_buf:   db      0,0,0,0,0,0,0,0,0
            endp
