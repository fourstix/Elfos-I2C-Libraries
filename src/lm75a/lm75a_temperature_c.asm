;-------------------------------------------------------------------------------
; lm75a_temperature_c - a routine to read the temperature in Celsius
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
#include ../include/lm75a_def.inc

;-------------------------------------------------------------------------------
; This routine reads the temperature in degrees Celsius
; Returns: 
;   RF = pointer to string with temperature in Celsius
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    lm75a_temperature_c
            push    ra                    ; save data pointer
            push    rd                    ; save index register

            call    i2c_rdreg
            db      I2C_ADDR
            db      1, TEMP_REG, 2        ; read 2 bytes from temperature register
            dw      temp_data
            lbdf    err_exit              ; if error, exit immediately        

            mov     ra, temp_data         ; get temperature byte
            mov     rf, temp_buf          ; convert int in RD to ascii string            
            ldi     0
            phi     rd                    ; clear out top byte
            lda     ra                    ; get first byte, signed temperature
            plo     rd                    ; LSB of integer
            ani     $80                   ; check sign bit of LSB
            lbz     convert               ; if positive, ready to convert
            ldi     '-'                   ; if negative, put minus sign 
            str     rf                    ; into temp_buf and
            inc     rf                    ; move to next character

            glo     rd                    ; if negative, convert to positive
            xri     $ff                   ; one's complement value
            plo     rd                    ; save and check half-degree byte          
            ldn     ra                    ; next byte has half-degree bit    
            ani     $80
            lbnz    convert               ; if half-degree bit, don't add one
            inc     rd                    ; add one for two's complement 


convert:    mov     rf, temp_buf          ; convert int in RD to ascii string
            call    f_intout

            mov     rd, rf                ; rf points to one after ascii string

            ldn     ra                    ; get next byte (fractional value)
            ani     $80                   ; check 1/2 degree bit
            lbz     finish                ; if 0, not half

            mov     rf, half_str          ; concat decimal string
            call    f_strcpy

finish:     mov     rf, unit_c            ; concat Celsius unit and eol 
            call    f_strcpy

err_exit:   pop     rd                    ; restore rd
            pop     ra                    ; restore ra
            mov     rf, temp_buf          ; point rf to temperature string

            return

temp_data:  db      0, 0
temp_buf:   db      0,0,0,0,0,0,0,0,0
half_str:   db      '.5',0
unit_c:     db      'C',0

            endp
