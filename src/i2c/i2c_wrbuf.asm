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
;This routine writes a message to the i2c bus.
;
;Parameters:
;   1: i2c_address     7-bit i2c address (1 byte)
;   2: num_bytes       number of bytes to write (1 byte)
;   3: address         address of message to be written (2 bytes)
;
;Example:
;   This call writes a 17 byte message to the i2c device at address 0x70:
;
;            CALL I2C_WRBUF
;            DB $70,17
;            DW BUFFER
;
; BUFFER:    DB $00
;            DB $06,$00,$5B,$00,$00,$00,$4F,$00
;            DB $66,$00,$00,$00,$00,$00,$00,$00
;
;Register usage:
;   R9.1 maintains the current state of the output port
;   RA   - function pointer to i2c write byte routine
;   RD   - pointer to write buffer
;   RF.0 - byte count
;   RF.1 - i2c write 
; Returns:
;   DF = 0 on success, DF = 1 on error
;------------------------------------------------------------------------

            proc    i2c_wrbuf
            
            ghi     ra
            stxd
            glo     ra
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

            ; Read parameters
            lda     r6              ; get i2c address
            shl                     ; add write flag
            phi     rf
            lda     r6              ; get count of bytes to write
            plo     rf              ; and save it.
            lda     r6              ; get high address of buffer
            phi     rd
            lda     r6              ; get low address of buffer
            plo     rd

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure i2c port group
            db      I2C_GROUP
            sex     r2
          #endif

            #include i2c_start.asm

            sep     ra              ; write address + write flag
            lbdf    wr_stop         ; report error if no device ack
next_byte:  lda     rd              ; get next byte
            phi     rf
            sep     ra              ; write data byte
            lbdf    wr_stop         ; error if device does not ack
            dec     rf
            glo     rf
            lbnz    next_byte

wr_stop:
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
            plo     ra
            ldx
            phi     ra
            return

            endp
