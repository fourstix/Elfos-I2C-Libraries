;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun 4 character 14-Segment
; Alphanumeric display with I2C running from an 1802-Mini Computer with the PIO 
; and I2C Expansion Boards. These routines are meant to be called using SCRT 
; in Elf/OS with X=R2 being the stack pointer.
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2022 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Sparkfun 4 Character 14-Segment Alphanumeric Display hardware
; Copyright 2019-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/categories/820 for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/ht16k33_def.inc
#include    ../include/alnum_lib.inc
#include    ../include/i2c_lib.inc

;-------------------------------------------------------------------------------
; This routine sets a segment of a character in the display buffer
;-------------------------------------------------------------------------------
; Parameters:
;   RA.0 - char position
;   RB.0 - segment to set (0 to D) => (segment a to n)
; Registers Used:
;   RC.0 - position bit shift count
;   RC.1 - bit mask for position bit
;   RD   - pointer to the display buffer
;-------------------------------------------------------------------------------

            proc    alnum_write_segment

            push    rd
            push    rc
            
            mov     rd, alnum_display_buf+1

            glo     rb            ; get segment to calculate address offset
            smi      7            ; check to see if segment greater than g
            lbdf    set_ptr       ; for h to n use offset = (seg - 7)
            glo     rb            ; seg value is offset for segments a to g  

set_ptr:    shl                   ; multiply offset by 2
            str     r2            ; save offset in M(X)            
            glo     rd            ; get lower byte of buffer pointer
            add                   ; add 2*offset to buffer pointer
            plo     rd            ; save updated buffer pointer byte
            ghi     rd            ; update upper byte of buffer pointer
            adci     0            ; with carry flag from lower byte arithmetic
            phi     rd            ; rd now points to char position to update
                      
            glo     rb            ; get segment to calculate position mask
            smi      7            ; check if segment less than h
            lbdf    upper_mask    ; for h to n, bit mask in upper nibble
            ldi     $01           ; set lower nibble mask bit for segments a to g
            lbr     calc_mask
upper_mask: ldi     $10           ; set upper nibble mask bit for segments h to n
          
calc_mask:  phi     rc            ; save initial mask in rc.1
            glo     ra            ; get position number
            plo     rc            ; put in rc for shifting mask

shift_mask: lbz     set_bit       
            ghi     rc            ; get previous mask
            shl                   ; shift mask
            phi     rc            ; save shifted mask
            dec     rc            ; count down
            glo     rc            ; check count
            lbr     shift_mask    ; until count goes to zero
                          
set_bit:    ldn     rd            ; get current value in buffer
            str     r2            ; save buffer value in M(X)
            ghi     rc            ; get bit mask
            or                    ; OR mask with data value to set segment on
            str     rd            ; save updated value back in display buffer
              
            pop     rc            ; restore registers saved
            pop     rd
            return

            endp
