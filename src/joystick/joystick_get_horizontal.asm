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
; Get the horizontal position from device as a 10-bit value.
; Registers Used:
;   RF = index pointer
; Returns: 
;   RD = 10-bit x value (0 to 1023)
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    joystick_get_horizontal
            push    rf
            
            call    i2c_rdreg           ; i2c address = $20
            db      $20, 1, $03         ; 1 byte register address
            db      2                   ; read 2 bytes from register 3
            dw      joy_x_pos
            lbdf    err_exit            ; if unable to read joystick, exit immediately
            
            load    rf, joy_x_pos       ; get x value from buffer
            lda     rf          
            phi     rd                  ; put MSB in RD.1
            ldn     rf
            plo     rd                  ; put LSB in RD.0

            ldi     $06                 ; shift RD right six times
            plo     rf                  ; put shift count in RF.0
shift:      shr16   rd                  ; shfit RD right (16 bits)
            dec     rf                  ; count down
            glo     rf    
            lbnz    shift               ; keep going until all shifted

err_exit:   pop     rf
            return

joy_x_pos:  db 0,0
            
            endp
