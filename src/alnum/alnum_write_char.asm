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
; This routine sets segment values for a character in the display buffer
;-------------------------------------------------------------------------------
; Parameters:
;   RB.0 - character
;   RA.0 - character position
; Registers Used:
;   RF.1 - character bits segments n-h
;   RF.0 - character bits segments g-a
;   RD   - pointer to the display buffer and character table
;   RC.0 - shift count
;   RC.1 - bit mask for position bit
;-------------------------------------------------------------------------------

            proc    alnum_write_char

            push    rf              ; save registers used
            push    rc
            push    rd
            
            ldi     $FF             ; set rf to rubout char as default
            plo     rf
            phi     rf  
            load    rd, alnum_chars
            glo     rb              ; get character
            smi     32              ; subtract space
            lbnf    calc_mask       ; if control char, show default char (rubout)          
            shl                     ; multiply by two
            str     r2              ; save offset in M(X)
            smi     192             ; check to see if out of range
            lbdf    calc_mask       ; if non-ASCII, show default char (rubout)
            
            glo     rd              ; add offset in M(X) to buffer pointer
            add                     ; add offset to lower byte
            plo     rd              ; save lower byte
            ghi     rd              ; get high byte of buffer pointer
            adci     0              ; add carry value into high byte
            phi     rd              ; rd now points to character bits
            
            lda     rd              ; get the h-m segment bits
            phi     rf              ; save in rf.1
            ldn     rd              ; get a-g segments
            plo     rf              ; save in rf.0
            


calc_mask:  ldi     $10           ; set upper nibble mask bit for segments h to n
            phi     rc            ; save initial mask in rc.1
            glo     ra            ; get position number
            plo     rc            ; put in rc for shifting mask

shift_mask: lbz     set_h2m       
            ghi     rc            ; get previous mask
            shl                   ; shift mask
            phi     rc            ; save shifted mask
            dec     rc            ; count down
            glo     rc            ; check count
            lbr     shift_mask    ; until count goes to zero

set_h2m:    load    rd, alnum_display_buf+1
            ldi      7            ; save bit count
            plo     rc            ; save shift count
            ghi     rc            ; get bit mask
            str     r2            ; save mask at M(X)
set_bit1:   ghi     rf            ; get the h to m character bits
            shr                   ; shift segment bit into DF
            phi     rf            ; save shifted value
            lbnf    no_seg1       ; if DF = 0, segment is dark
            ldn     rd            ; get the byte
            or                    ; or with mask to set segment
            str     rd            ; save updated byte in display buffer
            
no_seg1:    inc     rd            ; move 2 bytes to next segment in display
            inc     rd
            dec     rc            ; count down
            glo     rc            ; check count
            lbnz    set_bit1      ; keep going for all seven segment bits 
            

set_a2g:    load    rd, alnum_display_buf+1            
            ldi      7            ; save bit count
            plo     rc            ; save shift count
            ghi     rc            ; get bit mask
            shr                   ; shift mask down into lower nibble
            shr                   ; same position mask but 4 bits to right
            shr                   ; upper nibble is filled with zeros
            shr                   ; position mask is now in lower nibble
            str     r2            ; save mask at M(X)

set_bit2:   glo     rf            ; get the a to g character bits
            shr                   ; shift segment bit into DF
            plo     rf            ; save shifted value
            lbnf    no_seg2       ; if DF = 0, segment is dark
            ldn     rd            ; get the byte
            or                    ; or with mask to set segment
            str     rd            ; save updated segment byte in buffer
            
no_seg2:    inc     rd            ; move 2 bytes to next segment bytes in display
            inc     rd
            dec     rc            ; count down
            glo     rc            ; check count
            lbnz    set_bit2      ; keep going for all seven segment bits 

            pop     rd            ; restore saved registers
            pop     rc
            pop     rf
            
            return

            endp
