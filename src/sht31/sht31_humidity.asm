;-------------------------------------------------------------------------------
; sht31_humidity - a routine to calculate the relative humidity from data read
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
; This routine converts the humidity data read from the sensor into a 
; string with the value in percent.
; Registers Used:
;   RD - Multiplicand register
;   RC - 32-bit Product register (Upper word)
;   RB - 32-bit Product register (Lower word)
; Returns: 
;   RF = pointer to string with relative humidity
;-------------------------------------------------------------------------------

            proc    sht31_humidity
            ;-----  rf is used for return so no need to save/restore
            
            push    rd                  ; save multiplicand register
            push    rc                  ; save Hi Word product register
            push    rb                  ; save Lo Word product register
            
            ;-----  point rf to humidity data in buffer      
            load    rf, sht31_data_buf+3  
            lda     rf                  ; get MSB of humidity reading
            phi     rd
            lda     rf                  ; get LSB of humidity reading
            plo     rd                  ; RD has humidity reading (multiplicand)
            inc     rd                  ; add one so 100% is possible

            load    rf, 1000            ; point rf to multiplier (for 10x value)        
            call    util_full_mult16    ; convert temperature word to hex
            
            ;----- high word in rc is the result         
            copy    rc,rd               ; copy result to rd
            
            load    rf, rh_buf          ; point rf to string buffer
            ldi     '%'                 ; add percent at end of humidity
              
            call    util_write_10x      ; write as single precision decimal string            
            
            pop     rb                  ; restore register used by sht31_full_mult16
            pop     rc                  ; restore register used by sht31_full_mult16
            pop     rd                  ; restore multiplicand register
            
            load    rf, rh_buf          ; point rf to temperature string
            clc                         ; clear DF since we did arithmetic
            return 
            
rh_buf:     db      0,0,0,0,0,0,0          
            endp
