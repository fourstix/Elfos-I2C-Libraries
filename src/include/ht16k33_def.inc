;-------------------------------------------------------------------------------
; This library contains routines to support the various Adafruit LED backpack
; displays with I2C running from an 1802-Mini Computer with the PIO and 
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
; Adafruit LED Backpack Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; HT16K33 Constants used by various devices
;-------------------------------------------------------------------------------

#define COLON_OFFSET    5

#define BLINK_OFF       0
#define BLINK_2HZ       1
#define BLINK_1HZ       2
#define BLINK_HALFHZ    3


#define LED_ON     1
#define LED_OFF    0
#define LED_RED    1
#define LED_YELLOW 2
#define LED_GREEN  3

CMD_BRIGHT: equ     0e0h
CMD_BLINK:  equ     080h
DISP_ON:    equ     001h
OSC_ON:     equ     021h

I2C_ADDR:   equ     070h
I2C_ADDR2:  equ     071h
