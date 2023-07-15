;-------------------------------------------------------------------------------
; util_full_multiply16 - Multiplies two 16-bit numbers to get a 32-bit result.
;
; Copyright 2023 by Gaston Williams
;
; Based on original code written by David Madole
; Copyright 2022-2023 David S. Madole <david@madole.net>
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; Multiply two 16-bit numbers to get a 32-bit result. The input
; numbers are in RF and RD and the result is returned in RC:RB
; with the inputs left unchanged. The algorithm used is regular
; long multiplication but with two optimizations applied:
;
; Rather than adding the multiplicand to the low word of the
; product accumulator and shifting the multiplicand left at each
; round, the multiplicand is instead added to the high word and
; the product is shifted right. This means only 16 bits need to
; be added rather than 32 bits.
;
; Since the low word of the product is unused until bits are
; shifted right into it from the high word, we can place the
; multiplier there and the single shift operation will now
; shift both the product and multiplier at the same time.
;
; Together, these optimization reduce the number of addition
; operations by half, and the number of shifts by a third. As a
; theoretical side benefit, the input operands are unchanged.
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc

;-------------------------------------------------------------------------------
;  Multiply two 16-bit numbers to get a 32-bit result, so that RC:RB = RD * RF 
; Parameters:
;   RD - 16 bit multiplicand
;   RF - 16 bit multiplier
; Returns:
;   RC - Upper word of 32-bit product
;   RB - Lower word of 32-bit product
;-------------------------------------------------------------------------------
 
            proc util_full_mult16
            ldi   16                    ; 16 bits to process
            plo   re

            ldi   0                     ; clear high 16 bits of output
            plo   rc
            phi   rc

            ghi   rf                    ; copy multiplier into low 16 bits
            shrc                        ;  of product while shifting first bit
            phi   rb
            glo   rf
            shrc
            plo   rb

mulloop:    lbnf  mulskip               ; skip addition if bit is zero

            glo   rd                    ; add multiplicand into high 16 bits
            str   r2                    ;  of product
            glo   rc
            add
            plo   rc
            ghi   rd
            str   r2
            ghi   rc
            adc                         ; carry bit will get shifted in
            phi   rc

mulskip:    ghi   rc                    ; right shift product, while also
            shrc                        ;  shifting out next multiplier bit
            phi   rc
            glo   rc
            shrc
            plo   rc
            ghi   rb
            shrc
            phi   rb
            glo   rb
            shrc
            plo   rb

            dec   re                    ; keep going until 16 bits done
            glo   re
            lbnz  mulloop
            
            ; product is complete
            clc                         ; clear DF since we did arithmetic
            return                      
            endp
