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
; This routine reads a byte from an address in an i2c device.
;
; Parameters:
;   1: i2c_address      7-bit i2c address (1 byte inline)
;   RD = address        device address to write
;   D  =  data          byte to write 
;
; Example:
;   This call reads a data byte from address $0070 for the i2c device    
;   on the i2c bus at i2c address $50. On completion, the value read 
;   is returned in D
;
;           ldi 0
;           phi rd
;           ldi $70
;           plo rd
;
;           call i2c_rdaddr
;           db $50
;
; Registers Used:
;   R9.1 - maintains the current state of the output port
;   RA   - function pointer to i2c write byte routine
;   RB   - function pointer to i2c read byte routine
;   RC.0 - i2c read address
;   RF.0 - byte count
;   RF.1 - i2c read address
; Returns:
;   DF = 0 on success, DF = 1 on error
;------------------------------------------------------------------------

            proc    i2c_rdaddr

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

          #if I2C_GROUP
            sex     r3
            out     EXP_PORT        ; make sure i2c port group
            db      I2C_GROUP
            sex     r2
          #endif

            #include i2c_start.asm

            ;----- write the i2 address
            sep     ra              ; write address + write flag
            lbdf    rdr_stop

            ;----- write the two-byte device address            
            ghi     rd              ; get MSB of address
            phi     rf
            sep     ra              ; write MSB byte
            lbdf    rdr_stop

            glo     rd              ; get LSB of address
            phi     rf
            sep     ra              ; write LSB byte
            lbdf    rdr_stop
            
            ldi      0               ; clear Elf/os scratch register
            plo      re
            
            ; repeated start
            #include i2c_start.asm

            ; rewrite the i2c address with read bit set
            glo     rc
            ori     01h
            phi     rf
            sep     ra

            ;----- read one byte of data from the address
            sep     rb              ; read data byte
            ghi     rf
            plo     re              ; save byte in Elf/os scratch register
            
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
            plo     rc
            ldxa
            plo     rb
            ldxa
            phi     rb
            ldxa
            plo     ra
            ldx
            phi     ra

            glo     re                ; get return value for D
            return

            endp
