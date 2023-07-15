;-------------------------------------------------------------------------------
; This library supports the PIO and I2C Expansion cards running on the 1802-Mini 
; Computer to provide support for the i2c protocol.
;
; This library contains routines to implement the i2c protocol using two
; bits of a parallel port. The two bits should be connected to open-
; collector or open-drain drivers such that when the output bit is HIGH,
; the corresponding i2c line (SDA or SCL) is pulled LOW.
;
;*******************************************************************************
; Note:
; This internal routine is invoked through SEP by other library routines,
; and not called through SCRT by the Elf/OS!
;*******************************************************************************
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

;------------------------------------------------------------------------
;This routine writes one byte of data (MSB first) on the i2c bus.
;
; Parameters:
;   RF.1 on entry, contains the value to be written to the bus
; Registers Used:
;   R2   points to an available memory location (typically top of stack)
;   R9.1 maintains the current state of the output port
;   R9.0 bit counter
; Returns:
;   DF = 0 on success, DF = 1 on error
;------------------------------------------------------------------------

            proc    i2c_write_byte
            
            sep     r3

            ldi     8
            plo     r9
wr_next:    ghi     rf
            shlc
            phi     rf
            ghi     r9
            lbdf    wr_one
            ori     SDA_LOW         ; SDA low
            lskp
wr_one:     ani     SDA_HIGH        ; SDA high
            str     r2
            out     I2C_PORT
            dec     r2
            ani     SCL_HIGH        ; SCL high
            str     r2
            out     I2C_PORT
            dec     r2
            ori     SCL_LOW         ; SCL low
            str     r2
            out     I2C_PORT
            dec     r2
            phi     r9              ; update port data
            dec     r9
            glo     r9
            lbnz    wr_next
            ; ack/nak
            ghi     r9
            ani     SDA_HIGH        ; SDA high
            str     r2
            out     I2C_PORT
            dec     r2
            ani     SCL_HIGH        ; SCL high
            str     r2
            out     I2C_PORT
            dec     r2
stretch:    b4      stretch
            clc 
            b3      wr_ack
nak:        stc
wr_ack:     ori     SCL_LOW         ; SCL low
            str     r2
            out     I2C_PORT
            dec     r2
            phi     r9

            lbr     i2c_write_byte

            endp
