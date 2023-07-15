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


;-------------------------------------------------------------------------------
;This routine writes the id to the i2c bus to see if a device is available
;
;Parameters:
;   RF.0 - 7-bit i2c address to scan
;Register usage:
;   R9.1 maintains the current state of the output port
;   RA   - function pointer to i2c write byte routine
;   RF.1 - consumed for i2c write address 
; Returns:
;   DF = 0 if found, DF = 1 if not found 
;------------------------------------------------------------------------

            proc    i2c_scan

            glo     r9                  ; save registers
            stxd            
            ghi     ra
            stxd
            glo     ra
            stxd
            ghi     rf
            stxd
            glo     rf
            stxd


            ; Set up sep function calls
            mov     ra, i2c_write_byte+1

            ; Read parameters
            glo     rf              ; get i2c address to scan
            shl                     ; add write flag
            phi     rf

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure i2c port group
            db      I2C_GROUP
            sex     r2
          #endif

            #include i2c_start.asm

            sep     ra              ; write address + write flag

            #include i2c_stop.asm

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure default expander group
            db      NO_GROUP
            sex     r2
          #endif

            irx                     ; restore registers
            ldxa
            plo     rf
            ldxa
            phi     rf
            ldxa
            plo     ra
            ldxa
            phi     ra
            ldx
            plo     r9
            return

            endp
