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
;
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------
#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/ht16k33_def.inc  
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------
; Private routine - called only by the public routines
; These routines may *not* validate or clip. They may 
; also consume register values passed to them.
;-------------------------------------------------------

;-------------------------------------------------------
; Name: gfx_write_rect
;
; Set pixels for a rectangle in the display buffer at 
; position x,y.
;
; Parameters: 
;   r9.1 - color
;   r8.1 - h 
;   r8.0 - w 
;   r7.1 - origin y 
;   r7.0 - origin x 
;
; Registers Used:
;   rb - origin
;   ra - dimensions
;
; Return:
;   DF = 1 if error, 0 if no error (r7 & r9 consumed)
;-------------------------------------------------------
            proc    gfx_write_rect

            push    rb        ; save origin registers
            push    ra        ; save dimension register
            
            copy    r7, ra    ; save origin 
            copy    r8, rb    ; save dimensions
            
            glo     r8        ; get w for length
            plo     r9        ; set up length of horizontal line

            call    gfx_write_h_line   ; draw top line 
            lbdf    wr_done            ; if error, exit immediately

            copy    ra, r7    ; restore origin
            copy    rb, r8    ; restore w and h values
            ghi     r8        ; get h for length
            plo     r9        ; set up length of vertical line

            call    gfx_write_v_line   ; draw left line
            lbdf    wr_done            ; if error, exit immediately
            
            copy    rb, r8    ; restore h and w values
            glo     ra        ; get origin x
            plo     r7        ; restore origin x
            ghi     ra        ; get origin y
            str     r2        ; put y0 in M(X)
            ghi     r8        ; get h
            add               ; D = y0 + h
            phi     r7        ; set new origin at lower left corner
            glo     r8        ; get w for length
            plo     r9        ; set length for horizontal line

            call    gfx_write_h_line   ; draw bottom line
            lbdf    wr_done            ; if error, exit immediately
            
            copy    rb, r8    ; restore w and h values
            ghi     ra        ; get origin y
            phi     r7        ; restore origin y
            glo     ra        ; get origin x
            str     r2        ; put x0 in M(X)
            glo     r8        ; get w
            add               ; D = x0 + w
            plo     r7        ; set origin to upper right corner
            ghi     r8        ; get h for length
            plo     r9        ; set length for vertical line

            call    gfx_write_v_line   ; draw right line
            
wr_done:    pop     ra         ; restore registers
            pop     rb
            return 
            endp  
