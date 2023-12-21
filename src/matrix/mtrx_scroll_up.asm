;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit LED matrix
; display with I2C running from an 1802-Mini Computer with the PIO and 
; I2C Expansion Boards. 
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
; Based on code from Adafruit_GFX library
; Written by Limor Fried/Ladyada for Adafruit Industries  
; Copyright 2012 by Adafruit Industries
; Please see https://learn.adafruit.com/adafruit-gfx-graphics-library for more info
;-------------------------------------------------------------------------------
#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/util_lib.inc 
#include    ../include/gfx_lib.inc 
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------
; Private routine - called only by the public routines
; These routines may *not* validate or clip. They may 
; also consume register values passed to them.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: mtrx_scroll_up
;
; Write a 6x8 character to the display buffer, moving
; it upwards as a new 6x8 character replaces it in the
; display buffer. 
; 
;
; Parameters: 
;   r9.1 - color
;   r9.0 - rotation
;   rd.0 - previous character
;   rd.1 - new character
; Registers Used:
;   r7.1 - origin y 
;   r7.0 - origin x 
;   r8   - character write scratch register
;   r8.0 - character to write
;   ra.0 - scroll counter
;   rc   - scratch register, copy of origin
;
; Note: Checks to see if any possible overlap with the
;   display before drawing bitmap.
;                  
; Return: DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_scroll_up
            
            push    rc                ; save registers used
            push    ra
            push    r9                
            push    r8
            push    r7

            ldi     C_HEIGHT          ; set scroll counter
            plo     ra  
            
            ldi     1                 ; set previous origin to 1,0
            plo     r7                ; set x origin
            ldi     0
            phi     r7                ; set y origin
            
sl_loop:    ghi     rd                ; get previous character
            plo     r8                ; write previous character
            
            call    mtrx_clear        ; clear out display buffer
            
            copy    r7,rc             ; save origin in scratch register
            
            call    gfx_draw_char     ; r7  is consumed
            lbdf    sl_exit
            
            glo     rc                ; get x origin from scratch register
            plo     r7                ; restore r7.1
            
            ghi     rc                ; get y origin value from scratch reg
            adi     C_HEIGHT          ; signed addition to calculate
            phi     r7                ; set y origin for next bitmap
            
            clc                       ; clear DF flag after arithmetic
            
            glo     rd                ; get next character
            plo     r8                ; write next character
            call    gfx_draw_char    ; r7 is consumed
            lbdf    sl_exit

            glo     rc                ; get x origin from scratch register
            plo     r7                ; restore r7.0
            
            ghi     rc                ; get y origin for previous bitmap
            smi     1                 ; shift y origin up (signed value)
            phi     r7                ; save as new previous y origin 

            dec     ra                ; count down

            clc                       ; clear DF 
            call    mtrx_update
            lbdf    sl_exit
              
            load    rc, DELAY_100MS   ; wait a bit before continuing
            call    util_delay
            
            glo     ra                ; check counter
            lbnz    sl_loop           ; keep going to completely shifted
              
sl_exit:    pop     r7                ; restore registers        
            pop     r8
            pop     r9
            pop     ra
            pop     rc

            return

            endp
