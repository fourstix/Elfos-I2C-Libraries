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
; Name: gfx_write_line
;
; Write a line in the display buffer from position r7
; to position r8. 
;
; Parameters: r7.1 - origin y 
;             r7.0 - origin x 
;             r8.1 - endpoint y 
;             r8.0 - endpoint x 
;             r9.1 - color
;             r9.0 - length
;                  
; Return: r7, r8, r9 - consumed
;-------------------------------------------------------
            proc    gfx_write_line
            ghi     r7                ; get origin y
            str     r2                ; save at M(X)
            ghi     r8                ; get endpoint y
            sd                        ; check for horizontal line 
            lbnz    wl_vchk           ; if not zero check for vertical line

            glo     r7                ; get origin x
            str     r2                ; save at M(X)
            glo     r8                ; get endpoint x
            sm                        ; length = Endpoint - Origin
            plo     r9                ; put in temp register
            lbdf    wl_horz           ; if positive, we're good to go

            glo     r9                ; get negative length 
            sdi     0                 ; negate it (-D = 0 - D)
            plo     r9                ; put length in temp register
            swap    r7,r8             ; swap so origin is left of endpoint

wl_horz:    call    gfx_write_h_line
            lbr     wl_done

wl_vchk:    glo     r7                ; get origin x
            str     r2                ; save at M(X)
            glo     r8                ; get endpoint x
            sm
            lbnz    wl_slant          ; if not vertical, then slanted
                        
            ghi     r7                ; get origin y
            str     r2                ; save at M(X)
            ghi     r8                ; get endpoint y
            sm                        ; length = endpoint - origin
            plo     r9                ; put in temp register
            lbdf    wl_vert           ; if positive, we're good 

            glo     r9                ; get negative length
            sdi     0                 ; negate length 
            plo     r9                ; put length in temp register
            swap    r7,r8             ; make sure origin is above endpoint
            
wl_vert:    call    gfx_write_v_line
            lbr     wl_done
            
            ; r9.0 is used as steep flag for drawing a sloping line             
wl_slant:   call    gfx_steep_flag          

            glo     r9                ; check steep flag
            lbz     wl_schk           ; if not steep, jump to check for swap

            flip    r7                ; for steep line, flip origin x,y to y,x      
            flip    r8                ; for steep line, flip endpoint x,y to y,x

wl_schk:    glo     r7                ; make sure origin x is left of endpoint x
            str     r2                ; save origin x at M(X)
            glo     r8                ; get endpoint x
            sm                             
            lbdf    wl_slope          ; if positive, the okay (x1 - x0 > 0)

            swap    r7,r8             ; swap so origin is left of endpoint       
   
wl_slope:   call    gfx_write_s_line  ; draw a sloping line   

wl_done:    clc                       ; make sure DF = 0
            return
            
            endp
