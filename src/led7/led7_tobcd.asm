;-------------------------------------------------------------------------------
; This library contains routines to support the Adafruit 4 digit 7-segment
; display with I2C running from an 1802-Mini Computer with the PIO and 
; I2C Expansion Boards. These routines are meant to be called using SCRT 
; in Elf/OS with X=R2 being the stack pointer.
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
; Adafruit 4 Digit 7-Segment Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc

;------------------------------------------------------------------------
; This routine converts a hexadecimal number in RC.0 to a string of 
; three BCD (Binary Coded Decimal) digits in a buffer.
;
; Parameters:
; RC.0 contains the hexadecimal number
; RF points to the buffer location (3 bytes)
;
; Note: RC.0 is consumed
;       RF points to the last BCD digit after conversion.
;------------------------------------------------------------------------

            proc    led7_tobcd

            ldi     0
            str     rf
            glo     rc
            smi     200
            lbnf    lp100
            plo     rc
            ldn     rf
            adi     2
            str     rf
lp100:      glo     rc
            smi     100
            lbnf    lp80
            plo     rc
            ldn     rf
            adi     1
            str     rf
lp80:       inc     rf
            ldi     0
            str     rf
            glo     rc
            smi     80
            lbnf    lp40
            plo     rc
            ldn     rf
            adi     8
            str     rf
lp40:       glo     rc
            smi     40
            lbnf    lp20
            plo     rc
            ldn     rf
            adi     4
            str     rf
lp20:       glo     rc
            smi     20
            lbnf    lp10
            plo     rc
            ldn     rf
            adi     2
            str     rf
lp10:       glo     rc
            smi     10
            lbnf    lp1
            plo     rc
            ldn     rf
            adi     1
            str     rf
lp1:        inc     rf
            glo     rc
            str     rf
            rtn

            endp
