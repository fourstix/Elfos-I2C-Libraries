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
; Name: gfx_adj_bounds
;
; Adjust the values h,w so that they represent pixel 
; drawing lengths h' = h-1, w' = w-1 and the origin plus 
; h',w' are inside the display boundaries.
;
; Parameters:
;   r7.1 - y0 signed byte
;   r7.0 - x0 signed byte
;   r8.1 - h  
;   r8.0 - w
;
; Returns: DF = 1 if error, 0 if no error
;   r8.1 - h' = h-1, adjusted so that 0 <= y0 + h' <= 7 
;   r8.0 - w' = w-1, adjusted so that 0 <= x0 + w' <= 7
;
; Note: Values x and y are unsigned byte values. The
;   dimension values inclusive of the origin, and 
;   are converted to lengths that exclude the origin 
;   so that h' = h-1 and w' = w-1.
;-------------------------------------------------------
            proc    gfx_adj_bounds
            ghi     r8                ; check h first
            ani     $0F               ; h must be 1 to 8, clear out any high bits
            lbz     bad_clip          ; height should be > 0
            smi      1                ; adjust height by 1 for length h'
            phi     r8                ; save adjusted h' value
            ghi     r7  
            str     r2                ; put origin y value in M(X)
            ghi     r8                ; get adjusted height
            add                       ; D = y0 + h'
            smi     DISP_HEIGHT       ; anything over 7 is too big
            lbnf    check_w           ; if y0 + h' <= 7, h' is okay
            adi     $01               ; add one to adjust overage
            str     r2
            ghi     r8                ; get adjusted height h'
            sm                        ; subtract overage
            phi     r8                ; adjust h'
            lbnf    bad_clip          ; h' should not be negative
              
check_w:    glo     r8                ; check w
            ani     $0F               ; w must be 1 to 8, so clear high bits
            lbz     bad_clip          ; w should not be zero 
            smi     1                 ; subtract 1 for length w'
            plo     r8                ; save adjusted w' value
            glo     r7                ; get origin x values
            str     r2                ; put origin y value in M(X)
            glo     r8                ; get adjusted width w'
            add                       ; D = x0 + w'
            smi     DISP_WIDTH        ; anything over 7 is too big
            lbnf    clip_done         ; if x0 + w' <= 7, w' is okay
            adi     $01               ; add one to adjust overage
            str     r2
            glo     r8                ; get w'  
            sm                        ; subtract overage
            plo     r8
            lbdf    clip_done         ; w' should be positve        

bad_clip:   stc                       ; otherwise, exit with error
            return

clip_done:  clc                       ; clear df (no error)
            return
            endp
