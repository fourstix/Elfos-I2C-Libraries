;-------------------------------------------------------------------------------
; This module defines the routines required for GFX display interface to support
; the Adafruit LED matrix display with I2C running from an 1802-Mini Computer
; with the PIO and I2C Expansion Boards. 
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
#include    ../include/gfx_display.inc
#include    ../include/mtrx_def.inc

;-------------------------------------------------------------------------------
; This routine returns the device size
; Returns:
;   RA.1 = Device height
;   RA.0 = Device width
;-------------------------------------------------------------------------------

            proc    gfx_disp_size
            
            ldi     MTRX_HEIGHT
            phi     ra
            ldi     MTRX_WIDTH
            plo     ra
            return
            endp

;-------------------------------------------------------------------------------
; This routine clears the display buffer
;-------------------------------------------------------------------------------
            proc    gfx_disp_clear
                
            lbr     mtrx_clear    ; transfer to device routine
            endp

;-------------------------------------------------------
; Name: gfx_disp_pixel
;
; Set a pixel byte in the display buffer at position x,y.
;
; Parameters:
;   r9.1 - color
;   r7.1 - y 
;   r7.0 - x
; Return:
;   DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    gfx_disp_pixel
            lbr     mtrx_write_pixel  ; tranfer to device routine
            endp

;-------------------------------------------------------
; Name: gfx_disp_v_line
;
; Draw a vertical line starting at position x,y.
;
; Parameters: 
;   r9.1 - color 
;   r9.0 - length  (0 to 7)   
;   r7.1 - origin y 
;   r7.0 - origin x 
;                  
; Return:
;   DF = 1 if error, 0 if no error (r7 & r9 consumed)
;-------------------------------------------------------
            proc   gfx_disp_v_line
            
wv_loop:    call    mtrx_write_pixel  ; default routine, with no optimization
            lbdf    wv_done           ; if error, exit immediately
            
            ghi     r7                ; move y to next position
            adi      1
            phi     r7                ; save updated y value
            
            glo     r9                ; check length count
            lbz     wv_done           ; if zero we are done
            
            dec     r9                ; draw length of w pixels
            lbr     wv_loop            
wv_done:    return

            endp

;-------------------------------------------------------
; Name: gfx_disp_h_line
;
; Draw a horizontal line starting at position x,y.
;
; Parameters: 
;   r9.1 - color 
;   r9.0 - length  (0 to width-1)   
;   r7.1 - origin y 
;   r7.0 - origin x 
;                  
; Return:
;   DF = 1 if error, 0 if no error (r7 & r9 consumed)
;-------------------------------------------------------
            proc    gfx_disp_h_line

wh_loop:    call    mtrx_write_pixel  ; default routine, with no optimization
            lbdf    wh_done           ; if error, exit immediately
            
            inc     r7                ; move x to next position
            
            glo     r9                ; check length count
            lbz     wh_done           ; if zero we are done
            inc     rd                ; move ptr to next byte
            dec     r9                ; draw length of w pixels
            lbr     wh_loop            

wh_done:    return

            endp
