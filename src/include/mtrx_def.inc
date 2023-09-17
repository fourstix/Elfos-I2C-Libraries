;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit LED matrix
; displays with I2C running from an 1802-Mini Computer with the PIO and 
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

;-------------------------------------------------------------------------------
; LED matrix display constants
;-------------------------------------------------------------------------------

#define DISP_HEIGHT     8
#define DISP_WIDTH      8

;-------------------------------------------------------------------------------
; Character constants
;-------------------------------------------------------------------------------

#define C_OFFSET     32
#define C_ERROR      95
#define C_WIDTH       6
#define C_HEIGHT      8

;-------------------------------------------------------------------------------
; Routines used by library routines
;-------------------------------------------------------------------------------
            extrn   i2c_avail
            extrn   i2c_wrbuf
            extrn   mtrx_clear
            extrn   mtrx_write_disp
            extrn   mtrx_display_buf

;-------------------------------------------------------------------------------
; Graphics routines used by library routines
;-------------------------------------------------------------------------------
            extrn   gfx_check_bounds  
            extrn   gfx_write_pixel      
            extrn   gfx_adj_bounds  
            extrn   gfx_write_bitmap      
            extrn   gfx_check_overlap  
            extrn   gfx_ascii_font  
            extrn   gfx_write_char      
            extrn   gfx_scroll_left
            extrn   gfx_scroll_up
            extrn   gfx_write_h_line 
            extrn   gfx_write_v_line 
            extrn   gfx_write_rect
            extrn   gfx_write_block  
            extrn   gfx_write_s_line 
            extrn   gfx_steep_flag 
            extrn   gfx_write_line 
