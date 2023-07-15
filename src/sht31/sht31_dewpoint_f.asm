;-------------------------------------------------------------------------------
; sht31_dewpoint_f - a routine to get the dewpoint in Fahrenheit from data read
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
#include ../include/util_lib.inc
#include ../include/sht31_lib.inc

;-------------------------------------------------------------------------------
; This routine converts the humidity data read from the sensor into a 
; string with the value in percent.
; Registers Used:
;   RD - Multiplicand register
;   RC - 32-bit Product register (Upper word)
;   RB - 32-bit Product register (Lower word)
;   RA - Accumulator
; Returns: 
;   RF = pointer to string with relative humidity
;-------------------------------------------------------------------------------

            proc    sht31_dewpoint_f
            ;-----  rf is used for return so no need to save/restore
            
            push    rd                  ; save multiplicand register
            push    rc                  ; save Hi Word product register
            push    rb                  ; save Lo Word product register
            push    ra                  ; save accumulator register

            load    rf, sht31_data_buf  ; point rf to temperature data
            lda     rf                  ; get MSB of temperature reading
            phi     rd
            lda     rf                  ; get LSB of temperature reading
            plo     rd                  ; RD has temperature reading (multiplicand)
            
            ;-------------------------------------------------------------------
            ; First calculate dewpoint in C as a 1x value
            ;-------------------------------------------------------------------
            ;-------------------------------------------------------------------
            ;  A good approximation formula for calculating the dewpoint 
            ;  temperature  under normal weather conditions is:
            ;     DP ~= T - (100 - H)/5
            ;  Where T is the temperature in degrees C, range +/- 40C
            ;     H is relative humidity in integer %, range 0 to 100 
            ;  This is the 10X formula implemented below.
            ;-------------------------------------------------------------------
            ;  For more information, please see:
            ;
            ;  How do I calculate dew point when I know the temperature and the 
            ;   relative humidity? by Michael Bell (2007)
            ;   https://iridl.ldeo.columbia.edu/dochelp/QA/Basic/dewpoint.html 
            ;
            ;  The relationship between relative humidity and the dewpoint 
            ;   temperature in moist air: A simple conversion and applications.
            ;   by Mark G Lawrence (2005)
            ;   http://dx.doi.org/10.1175/BAMS-86-2-225 
            ;-------------------------------------------------------------------------------

            load    rf, 175             ; point rf to multiplier (for 10X value)        
            call    util_full_mult16    ; convert temperature word to hex
                    
            SUB16   rc, 45              ; subtract -45 from product hi word
            
            copy    rc,ra               ; copy 1X result to accumulator

            SUB16   ra, 20              ; subtract 200 from 10X value

            ;-----  point rf to humidity data in buffer      
            load    rf, sht31_data_buf+3  
            lda     rf                  ; get MSB of humidity reading
            phi     rd
            lda     rf                  ; get LSB of humidity reading
            plo     rd                  ; RD has humidity reading (multiplicand)
            inc     rd                  ; add one so 100 is possible

            load    rf, 100             ; point rf to multiplier (for 1x value)        
            call    util_full_mult16    ; convert temperature word to hex

            copy    rc,rf               ; copy 1x humidity to dividend
            load    rd, 5               ; set divisor
            
            call    f_div16             ; integer divide, quotient in rb, remainder in rf
            
            add16   ra,rb               ; add RH/5 from accumulator
            
            ;-----  ra has the dewpoint in C as 1X value
            glo     rf                  ; get remainder (less than 5)
            smi     3                   ; set DF if remainder > 2
            
            ;-----  DF is the half-bit flag for conversion
            copy    ra,rd               ; copy accumulator for conversion
            
            call    util_c_to_f        ; convert rd to Fahrenheit string

            ;-----  rd has 10X value of temperature in Fahrenheit
            load    rf, f_dp_buf        ; point rf to string buffer
            ldi     'F'                 ; set unit character
            call    util_write_10x     ;
            
            pop     ra                  ; restore accumulator register
            pop     rb                  ; restore lo word product register 
            pop     rc                  ; restore hi word prodcut register
            pop     rd                  ; restore multiplicand register
            
            load    rf, f_dp_buf        ; point rf to temperature string
            clc                         ; clear DF since we did arithmetic
            return 
            
f_dp_buf:   db      0,0,0,0,0,0,0,0          
            endp
            
            
