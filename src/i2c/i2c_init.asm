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
; These routines are meant to be called using the SCRT in Elf/OS, with X=R2 
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


;-------------------------------------------------------------------------------
; This routine initializes the i2c bus and clears the output port register.
;
; Parameters:
;   (none)
;
; Example:
;   This call initializes the i2c bus:
;
;            CALL I2C_INIT
;
; Register usage:
;   R9.1 - set up the initial state of the output port
;   RA   - function pointer to i2c write byte routine
;   RF.1 - i2c write 
; 
; Returns:
;   R9.1 - the current state of the output port ($00)
;   DF = 0 (always successful)
;------------------------------------------------------------------------

            proc    i2c_init
            
            sex     r3                  ; set X = P for inline data
  
          #if I2C_GROUP
            out     EXP_PORT
            db      I2C_GROUP
          #endif
            
            out     I2C_PORT            ; init i2c output port
            db      0
            
            ldi     0                   ; current state of port
            phi     r9                  ; is kept in R9.1

          #if I2C_GROUP
            out     EXP_PORT            ; make sure default expander group
            db      NO_GROUP
          #endif

            sex     r2                  ; set X back to stack for return
            clc                         ; DF=0 (always successful)
            return

            endp
