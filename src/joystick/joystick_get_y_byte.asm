;-------------------------------------------------------------------------------
; This library contains routines to support the Sparkfun Qwiic Joystick
; with I2C running from an 1802-Mini Computer with the PIO and I2C Expansion
; Boards. These routines are meant to be called using SCRT in Elf/OS 
; with X=R2 being the stack pointer.
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
; Sparkfun Qwiic Joystick hardware
; Copyright 2018-2023 by Sparkfun Industries
; Please see https://www.sparkfun.com/products/15168 for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/i2c_lib.inc

;-------------------------------------------------------------------------------
; Get the y position from the joystick as an 8-bit value.
; Registers Used:
;   RF = pointer to buffer
; Returns: 
;   D  = 8-bit y value (0 to 255)
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    joystick_get_y_byte
            
            push    rf                  ; save buffer pointer
            call    i2c_rdreg           ; i2c address = $20
            db      $20, 1, $05         ; 1 byte register address
            db      1                   ; read 1 byte from register 5
            dw      joy_y_msb
            lbdf    err_exit            ; if unable to read joystick, exit immediately
            
            load    rf, joy_y_msb       ; get x value from buffer
            ldn     rf
            plo     re                  ; put MSB in Elf/os scratch register
            
err_exit:   pop     rf
            glo     re                  ; get MSB from scratch register
            return

joy_y_msb:  db 0
            
            endp
