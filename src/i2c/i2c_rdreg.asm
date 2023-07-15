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
; This routine reads a message from a register in an i2c device.
;
; Parameters:
;   1: i2c_address     7-bit i2c address (1 byte)
;   ?: num_bytes       number of bytes to write (1 byte) 
;   2: reg_id          register to read (num_bytea)
;   3: num_bytes       number of bytes to read (1 byte)
;   4: address         address of message buffer (2 bytes)
;
; Example:
;   This call reads a 2 byte value from register 3 from the i2c device at 
;   address $20. On completion, the value read is at H_POS:
;
;   READ_TEMP:  CALL I2C_RDREG
;               DB $20, $03, 2
;               DW H_POS
;
;   H_POS:  DS 2
;
; Registers Used:
;   R9.1 - maintains the current state of the output port
;   RA   - function pointer to i2c write byte routine
;   RB   - function pointer to i2c read byte routine
;   RC.0 - i2c read address
;   RD   - pointer to buffer
;   RF.0 - byte count
;   RF.1 - i2c read address
; Returns:
;   DF = 0 on success, DF = 1 on error
;------------------------------------------------------------------------

            proc    i2c_rdreg

            ghi     ra
            stxd
            glo     ra
            stxd
            ghi     rb
            stxd
            glo     rb
            stxd
            glo     rc
            stxd
            ghi     rd
            stxd
            glo     rd
            stxd
            glo     r9
            stxd
            ghi     rf
            stxd
            glo     rf
            stxd

            ; Set up sep function calls
            mov     ra, i2c_write_byte+1
            mov     rb, i2c_read_byte+1

            ; Read parameters
            lda     r6              ; get i2c address
            shl                     ; add write flag
            plo     rc              ; save shifted address
            phi     rf
            lda     r6              ; get count of bytes to write
            plo     rf              ; and save it.

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure i2c port group
            db      I2C_GROUP
            sex     r2
          #endif

            #include i2c_start.asm

            sep     ra              ; write address + write flag
            lbdf    rdr_stop
wloop:      lda     r6              ; get next byte
            phi     rf
            sep     ra              ; write next byte
            lbdf     rdr_stop
            dec     rf
            glo     rf
            lbnz    wloop

            lda     r6              ; save count of bytes
            smi     01h             ; minus one.
            plo     rf
            lda     r6              ; get high address of buffer
            phi     rd
            lda     r6              ; get low address of buffer
            plo     rd

            ; repeated start
            #include i2c_start.asm

            ; rewrite the i2c address with read bit set
            glo     rc
            ori     01h
            phi     rf
            sep     ra

            glo     rf
            lbz     rdr_last

rloop:      sep     rb              ; read next byte
            ghi     rf
            str     rd
            inc     rd

            ; ack
            ghi     r9
            ori     SDA_LOW         ; SDA low
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
            phi     r9

            dec     rf
            glo     rf
            lbnz    rloop

rdr_last:   sep     rb              ; read final byte
            ghi     rf
            str     rd

            ; nak
            ghi     r9
            ani     SDA_HIGH        ; SDA high
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
            phi     r9

            clc

rdr_stop:
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
            plo     r9
            ldxa
            plo     rd
            ldxa
            phi     rd
            ldxa
            plo     rc
            ldxa
            plo     rb
            ldxa
            phi     rb
            ldxa
            plo     ra
            ldx
            phi     ra
            return

            endp
