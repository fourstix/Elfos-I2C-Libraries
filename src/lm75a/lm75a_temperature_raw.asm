;-------------------------------------------------------------------------------
; lm75a_temperature_c - a routine to read the temperature using a
; LM75A sensor with I2C using the PIO Expansion Board for the 
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
; This routine reads the raw temperature data from the LM75A
; Registers Used:
;   RD   - pointer to the temperature buffer
; Returns: 
;   RF.1 = byte with signed temperature value in Celsius
;   RF.0 = byte with half-degree bit: $80 = add 0.5 degree C, $00 = no adjustment needed
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    lm75a_temperature_raw
            push    rd                    ; save index register

            call    i2c_rdreg
            db      I2C_ADDR              ; read temperature from LM75A
            db      1, TEMP_REG, 2        ; read 2 bytes from temperature register
            dw      temp_data
            lbdf    err_exit              ; if error, exit immediately

            load    rd, temp_data
            lda     rd                    ; get temperature byte 
            phi     rf                    ; save in Elf/os scratch register
            ldn     rd                    ; get byte with half-degree bit
            plo     rf                    ; Set D to temperature byte value

err_exit:   pop     rd
            return

temp_data:  db      0, 0

            endp
