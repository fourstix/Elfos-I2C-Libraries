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
; Get the current button state from the joystick.
; Registers Used:
;   RF = buffer pointer
; Returns: 
;   D  = button state (0 = Down, 1 = Up) 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    joystick_button_state
            push    rf
            
            call    i2c_rdreg           ; i2c address = $20
            db      $20, 1, $07         ; 1 byte register address
            db      1                   ; read 1 byte from register 7
            dw      joy_button
            lbdf    err_exit            ; if unable to read joystick, exit immediately
            
            load    rf, joy_button      ; get button value from buffer
            ldn     rf          
            plo     re                  ; put button value in Elf/os scratch register

err_exit:   pop     rf
            glo     re                  ; get button value from scratch register
            return

joy_button: db 0
            
            endp
