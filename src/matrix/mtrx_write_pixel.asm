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
;
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------
#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/mtrx_def.inc  

;-------------------------------------------------------
; Name: mtrx_write_pixel
;
; Set a pixel byte in the display buffer at position x,y.
;
; Parameters:
;   r7.1 - y (line, 0 to 7)
;   r7.0 - x (pixel offset, 0 to 7)
;   r9.1 - color
;   r9.0 - rotation
; Registers Used:
;   RD - pointer to the display buffer
;   RC.0 - bit mask for clearing bit (AND mask)
;   RC.1 - bit mask for setting bit (OR mask)                  
; Return:
;   DF = 1 if error, 0 if no error
;-------------------------------------------------------
            proc    mtrx_write_pixel
            push    rd                ; save buffer pointer register 
            push    rc                ; save bit mask register
            
            ldi     $01               ; bit mask for horizontal byte
            phi     rc                ; store bit mask in rc.1
            glo     r7                ; horizontal pixels, so get x position for bitmask
            plo     rc                ; store in bit counter rc.0
            
shft_bit:   lbz     set_masks
            ghi     rc
            shl                       ; shift mask one bit     
            phi     rc                ; save mask in rc.1
            dec     rc                ; count down
            glo     rc                ; check counter
            lbr     shft_bit          ; repeat until count down to zero

set_masks:  ghi     rc                ; get OR mask from rc.1
            xri     $FF               ; flip all bits
            plo     rc                ; save AND mask in rc.0

            ; point rd to display buffer   
            load    rd, mtrx_buffer 
            inc     rd                ; display bytes are one after position byte 

            ghi     r7                ; shift y to multiply by 2
            shl                       ; two bytes per line (green bits + red byte)
            str     r2                ; save y offset in M(X)
            glo     rd                ; get lo byte of display pointer
            add                       ; add offset
            plo     rd                ; save lo byte of display pointer
            ghi     rd                ; adjust hi byte with carry flag
            adci    0                 ; add carry flag to hi byte
            phi     rd                ; rd now points to green byte for line 
            
            ghi     r9                ; check the color value
            lbz     pixel_off         ; set pixel off
            smi     1                 ; check for red pixel
            lbz     pixel_red         ; turn pixel red
            smi     1 
            lbz     pixel_yel         ; turn pixel yellow
            smi     1
            lbz     pixel_grn         ; turn pixel green
            pop     rc                ; unknown color,exit with error
            pop     rd                ; restore registers
            stc                       ; set DF for error
            return                    ; return with error
            
pixel_off:  glo     rc                ; get bit off mask
            str     r2                ; save at M(X)
            ldn     rd                ; get green byte
            and                       ; mask off bit for x
            str     rd                ; save updated green byte
            inc     rd                ; move to red byte
            ldn     rd                ; get red byte
            and                       ; mask off bit for x
            str     rd                ; save updated red byte
            lbr     wp_done           ; exit

pixel_red:  glo     rc                ; get bit off mask
            str     r2                ; save at M(X)
            ldn     rd                ; get green byte
            and                       ; mask off bit for x
            str     rd                ; save updated green byte
            inc     rd                ; move to red byte
            ghi     rc                ; get bit on mask
            str     r2                ; save at M(X)
            ldn     rd                ; get red byte
            or                        ; set bit for x
            str     rd                ; save updated red byte
            lbr     wp_done           ; exit

pixel_yel:  ghi     rc                ; get bit on mask
            str     r2                ; save at M(X)
            ldn     rd                ; get green byte
            or                        ; set bit on for x
            str     rd                ; save updated green byte
            inc     rd                ; move to red byte
            ldn     rd                ; get red byte
            or                        ; set bit on for x
            str     rd                ; save updated red byte
            lbr     wp_done           ; exit

pixel_grn:  ghi     rc                ; get bit on mask
            str     r2                ; save at M(X)
            ldn     rd                ; get green byte
            or                        ; set bit on for x
            str     rd                ; save updated green byte
            inc     rd                ; move to red byte
            glo     rc                ; get bit off mask
            str     r2                ; save at M(X)
            ldn     rd                ; get red byte
            and                       ; mask off bit for x
            str     rd                ; save updated red byte
            
wp_done:    pop     rc                ; restore bit mask register 
            pop     rd                ; restore buffer ptr register
            clc                       ; DF = 0 for success
            return

            endp 
