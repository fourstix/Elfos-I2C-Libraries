;-------------------------------------------------------------------------------
; pcf8591_read - a function to read a byte from the pcf8591 8 Bit A/D D/A over
; I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
; 
; Copyright 2023 Milton 'Nick' DeNicholas
;
; This is an extension of Copyrighted work by Gaston Williams
; please see https://github.com/fourstix/Elfos-I2C-Libraries for more info
;
; Based on the the Elf-I2C library
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
;-------------------------------------------------------------------------------

#include ../../include/ops.inc
#include ../../include/bios.inc
#include ../../include/kernel.inc
#include ../../include/sysconfig.inc
#include ../../include/i2c_lib.inc
#include ../../include/pcf8591_def.inc

;-------------------------------------------------------------------------------
; Read a byte from the pcf8591 device. The pcf8591 device's current address is 
; defined in the pcf8591_def.inc file above
;    
; Example: 
;   The following reads 1 byte from the pcf8591. The byte is the result of the 
;   last analog to digital conversion. Note: First read after a power on reset 
;   (POR) will always be $80; next read after a reconfiguration will be the from
;   the configuration before, I.E. reads are 1 cycle behind configurations:
;           call    pcf8591_read       ; read A/D result
;           dw      buff_addr          ; where 1 byte result goes
;
; Returns: 
;     DF = 0 on success, DF = 1 if not found
;-------------------------------------------------------------------------------

            proc    pcf8591_read
            
            ghi     r8                 ; save working register
            stxd
            glo     r8
            stxd
                        
            mov     r8, read_buff      ; point to addr where the users result goes
            lda     r6                 ; get the msb part
            str     r8                 ;    of the 
            inc     r8                 ;       address
            lda     r6                 ;          get the lsb part of
            str     r8                 ;             the address
                        
            call    i2c_rdbuf          ; read from pcf8591 device
            db      I2C_ADDR , $01     ;    where 12c addr = I2C_ADDR for 1 bytes
read_buff:  dw      $00                ; address where user wants results placed - changed at runtime
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldx
            phi     r8
                        
            return                     ;   DF = 0 on success, DF = 1 on error 
                        
            endp
            