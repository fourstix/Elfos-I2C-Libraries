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
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Display Buffer for 8x8 Matrix LED display
;    1 position byte (always zero) followed by 
;    8 lines of 2 bytes per line: a green byte and a red byte
;    where bits 0 to 7 of each byte represents a pixel in the line
;    Total size of the display buffer is 17 bytes
;-------------------------------------------------------------------------------
                        
            proc    mtrx_buffer            
            db      0         ; position byte (always zero)                        
            db      0,0       ; line 0 byte for green bits, byte for red bits
            db      0,0       ; line 1 byte for green bits, byte for red bits  
            db      0,0       ; line 2 byte for green bits, byte for red bits
            db      0,0       ; line 3 byte for green bits, byte for red bits
            db      0,0       ; line 4 byte for green bits, byte for red bits
            db      0,0       ; line 5 byte for green bits, byte for red bits
            db      0,0       ; line 6 byte for green bits, byte for red bits
            db      0,0       ; line 7 byte for green bits, byte for red bits

            endp
