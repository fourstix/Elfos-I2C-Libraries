;-------------------------------------------------------------------------------
; util_c_to_f - a routine to convert the Celsius temperature (1X) value to a
; Fahrenheit temperature 10X value.
;
; Copyright 2023 by Gaston Williams
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/util_lib.inc

;-------------------------------------------------------------------------------
; This routine converts the Celsius temperature (1X) value to a Fahrenheit 
; temperature 10X value.
; Parameters:
;   RD - Temperature in C (1X value)
;   DF - half-bit value (1 = +0.5C, 0 if whole number in RD) 
; Registers Used:
; Returns: 
;   RD = Temperature in F (10X value)
;-------------------------------------------------------------------------------

            proc    util_c_to_f
            ;-----  rf is used for return so no need to save/restore
            glo     rd                  ; get first byte of temperature
            shlc                        ; shift half-degree bit into sum
            plo     rd                  ; sum = C*2
            ghi     rd                  ; rd is 16 bit sum
            shlc                        ; shift bit into upper byte of sum
            shl16   rd                  ; sum = C*4
            shl16   rd                  ; sum = C*8
            add16   rd, rf              ; sum = (C*8 + C) = C*9
            shl16   rd                  ; sum = 2*(C*9) = 18*C
            add16   rd, 320             ; sum = (18*C + 320) = 10F
            
            clc                         ; since we did math, make sure DF = 0  
            return
            
conv_buf:   db      0,0,0,0,0,0,0,0,0            
            endp
