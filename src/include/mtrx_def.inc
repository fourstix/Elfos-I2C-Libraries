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
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; LED matrix display constants
;-------------------------------------------------------------------------------

#define MTRX_HEIGHT     8
#define MTRX_WIDTH      8

;-------------------------------------------------------------------------------
; LED color display constants
;-------------------------------------------------------------------------------

#define LED_ON     1
#define LED_OFF    0
#define LED_RED    1
#define LED_YELLOW 2
#define LED_GREEN  3

;-------------------------------------------------------------------------------
; HT16K33 display constants
;-------------------------------------------------------------------------------

#define BLINK_OFF       0
#define BLINK_2HZ       1
#define BLINK_1HZ       2
#define BLINK_HALFHZ    3

;-------------------------------------------------------------------------------
; Routines used by library routines
;-------------------------------------------------------------------------------
            extrn   i2c_avail
            extrn   i2c_wrbuf
            extrn   mtrx_buffer
            extrn   mtrx_clear
            extrn   mtrx_update
            extrn   mtrx_write_pixel
            extrn   mtrx_scroll_left
            extrn   mtrx_scroll_up
            

;-------------------------------------------------------------------------------
; Device I2C Address
;-------------------------------------------------------------------------------

I2C_ADDR:   equ     070h

;-------------------------------------------------------------------------------
; HT16K33 display commands
;-------------------------------------------------------------------------------

CMD_BRIGHT: equ     0e0h
CMD_BLINK:  equ     080h
DISP_ON:    equ     001h
OSC_ON:     equ     021h
