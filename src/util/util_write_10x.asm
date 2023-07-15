;-------------------------------------------------------------------------------
; util_write_10X - a routine to write a 10X value into a buffer as a single 
; precision decimal value with a decimal point and unit.
;
; Copyright 2023 by Gaston Williams
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc

;-------------------------------------------------------------------------------
; This routine converts the 10X value to a single-precision decimal value with
; a Unit character at the end. For example, if RC=105 and D='C' would convert 
; to the string 10.5C in the specified buffer.
; Parameters:
;   RF = pointer to string buffer for result
;   RD = 10X value to write a single-precision decimal value (X/10)
;    D = Unit character (like 'C' or 'F', use 0 for no unit character)
; Registers Used:
;   RC - Scratch register
; Returns: 
;   RF = points to end of text string 
;-------------------------------------------------------------------------------

            proc    util_write_10x
            plo     re                  ; save D in Elf/os scratch register
            push    rc                  ; save scratch register
            copy    rd,rc               ; set scratch register to 10X value
            
            ;----- need to check for leading zero for small values (-0.9 to 0.9)
            ghi     rc                  ; check sign bit for negative value
            shl                         ; DF=1 means negative
            lbnf    pos_value           ; if negative number, neagate RC for absolute value
            glo     rc                  ; get lo byte 
            xri     $ff                 ; invert it
            adi     1                   ; add one
            plo     rc                  ; save in register
            ghi     rc                  ; get hi byte
            xri     $ff                 ; invert it
            adci    0                   ; add in carry flag
            phi     rc                  ; RC = -(RC)

            ;----- rc now has the absolute value of 10x value
pos_value:  ghi     rc                  ; check if upper byte is zero
            lbnz    convert             ; if not, no leading zero is necessary
            glo     rc                  ; check if lower byte < 10
            smi     9
            lbdf    convert             ; if no borrow (DF=1), we are okay
            
            ghi     rd                  ; check sign bit of signed value
            shl                         ; if negative, need minus and zero
            lbnf    lead_zero           ; if positive, just add a zero
            
            ldi     '-'                 ; minus sign at beginning of small negative
            str     rf                  ; move rf to next character
            inc     rf                  ; move rf to next character
            copy    rc,rd               ; convert the absolute value after "-0"

lead_zero:  ldi     '0'                 ; add leading zero
            str     rf                  ; put leading zero in buffer
            inc     rf                  ; advance pointer to next character
            
convert:    glo     re                  ; get Unit character from Elf/os scratch register
            plo     rc                  ; save in rc.0  (because call wipes out re.0 and D)
            
            ;----- RF points to string buffer
            ;----- RD has 10X value to convert to single precision decimal string
            ;----- RC.0 has unit character at end of value string
            
            call    f_intout            ; convert to ascii string
            
            dec     rf                  ; back rf up to last character
            ldn     rf                  ; get last character
            plo     rd                  ; save in rd.0
            
            ldi     '.'                 ; put decimal point before end
            str     rf
            inc     rf
            glo     rd
            str     rf                  ; put last character in buffer
            inc     rf
            glo     rc                  ; put unit at end of number string
            str     rf
            inc     rf
            ldi     0                   ; put null at end of string
            str     rf            
            
            pop     rc                  ; restore scratch register
            clc                         ; clear DF since we did arithmetic
            return 

            endp
