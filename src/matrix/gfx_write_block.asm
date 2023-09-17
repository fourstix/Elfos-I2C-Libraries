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
; Name: gfx_write_block
;
; Write pixels for a filled rectangle in the display 
; buffer at position x,y.
;
; Parameters: 
;   r9.1 - color
;   r8.1 - h 
;   r8.0 - w 
;   r7.1 - origin y 
;   r7.0 - origin x 
; Registers Used:
;   ra - origin 
;   rc - counter 
;
; Return: (None) r7, r8, r9 consumed
;-------------------------------------------------------
            proc    gfx_write_block

            push    ra        ; save origin registers
            push    rc        ; save counter register
            
            copy    r7, ra    ; save origin
            load    rc, 0     ; clear rc        
            
            glo     r8        ; get width
            plo     rc        ; put in counter
            inc     rc        ; +1 to always draw first pixel column, even if w = 0
            
            ghi     r8        ; get h for length
            plo     r9        ; set up length of vertical line
            
            ; draw vertical line at x
wb_loop:    call    gfx_write_v_line   
            lbdf    wb_exit   ; if error, exit immediately
            
            inc     ra        ; increment x for next column
            dec     rc        ; decrement count after drawing line
            
            ghi     r8        ; get h for length
            plo     r9        ; set up length of vertical line
            
            COPY    ra, r7    ; put new origin for next line
            glo     rc        ; check counter
            lbnz    wb_loop   ; keep drawing columns until filled
            
wb_exit:    pop     ra        ; restore registers
            pop     rc
            return 
            endp  
