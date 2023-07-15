;-------------------------------------------------------------------------------
; relay_avail - a routine to check the i2c bus for the presence of a 
; Sparkfun Qwiic single relay with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
;
; Based on the the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
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
#include    ../include/kernel.inc
#include    ../include/sysconfig.inc
#include    ../include/i2c_lib.inc

;-------------------------------------------------------------------------------
; This routine checks the i2c bus for the presence of a relay
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    joystick_avail
            
            call    i2c_avail
            db      $20                 ; joystick i2c address = $20

            return
            endp
