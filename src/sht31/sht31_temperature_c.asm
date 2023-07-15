;-------------------------------------------------------------------------------
; sht31_temperature_c - a routine to get the temperature in Celsius from data read
; from the SHT31 temperature and humidity sensor with I2C using the PIO 
; Expansion Board and I2C adaptor for the 1802/Mini Computer.
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
;
; Adafruit SHT31 Temperature & Humidity Sensor
; Copyright 2019-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/2857 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/i2c_lib.inc
#include ../include/sht31_lib.inc
#include ../include/util_lib.inc

;-------------------------------------------------------------------------------
; This routine converts the temperature data read from the sensor into a null
; string with the value in Celsius.
; Registers Used:
;   RD - Multiplicand register
;   RC - 32-bit Product register (Upper word)
;   RB - 32-bit Product register (Lower word)
; Returns: 
;   RF = pointer to string with temperature in Celsius
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_temperature_c
            ;-----  rf is used for return so no need to save/restore
            
            push    rd                  ; save multiplicand register
            push    rc                  ; save Hi Word product register
            push    rb                  ; save Lo Word product register
                  
            load    rf, sht31_data_buf  ; point rf to temperature data
            lda     rf                  ; get MSB of temperature reading
            phi     rd
            lda     rf                  ; get LSB of temperature reading
            plo     rd                  ; RD has temperature reading (multiplicand)

            load    rf, 1750            ; point rf to multiplier (for 10X value)        
            call    util_full_mult16    ; convert temperature word to hex
                    
            SUB16   rc, 450             ; subtract -45*10 from product hi word
            
            copy    rc,rd               ; copy result to rd
            
            load    rf, c_temp_buf      ; point rf to string buffer
            ldi     'C'                 ; set unit character for 10X conversion
            call    util_write_10x      ; write as single precision decimal string 
            
            pop     rb                  ; restore register used by sht31_full_mult16
            pop     rc                  ; restore register used by sht31_full_mult16
            pop     rd                  ; restore multiplicand register
            
            load    rf, c_temp_buf      ; point rf to temperature string
            clc                         ; clear DF since we did arithmetic
            return 
            
c_temp_buf: db      0,0,0,0,0,0,0,0          
            endp
