;-------------------------------------------------------------------------------
; This library supports the PIO and I2C Expansion cards running on the 1802-Mini 
; Computer to provide support for the i2c protocol.
;
; This library contains routines to implement the i2c protocol using two
; bits of a parallel port. The two bits should be connected to open-
; collector or open-drain drivers such that when the output bit is HIGH,
; the corresponding i2c line (SDA or SCL) is pulled LOW.
;
; The current value of the output port is maintained in register R9.1.
; This allows the routines to manipulate the i2c outputs without
; disturbing the values of other bits on the output port.
;
; These routines are meant to be called using the SCRT ine Elf/OS, with X=R2 
; being the stack pointer.
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2023 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2023 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/sysconfig.inc
#include    ../include/i2c_io.inc

            extrn   i2c_write_byte
            extrn   i2c_read_byte

;------------------------------------------------------------------------
; This routine attempts to clear a condition where a slave is out of
; sync and is holding the SDA line low.
;
; Registers Used:
;   R9.1 maintains the current state of the output port
; Returns:
;   DF = 0 on success, DF = 1 on error
;------------------------------------------------------------------------
            proc    i2c_clear

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure i2c port group
            db      I2C_GROUP
            sex     r2
          #endif

            ghi     r9
            ani     SDA_HIGH        ; SDA high
            str     r2
            out     I2C_PORT
            dec     r2
            bn3     done            ; if SDA is high, we're done
toggle:     ori     SCL_LOW         ; SCL low
            str     r2
            out     I2C_PORT
            dec     r2
            ani     SCL_HIGH        ; SCL high
            str     r2
            out     I2C_PORT
            dec     r2
            b3      toggle          ; keep toggling scl until sda is high
done:       phi     r9

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure default expander group
            db      NO_GROUP
            sex     r2
          #endif
            
            CLC                     ; DF=0, return success once error is cleared
            rtn

            endp
