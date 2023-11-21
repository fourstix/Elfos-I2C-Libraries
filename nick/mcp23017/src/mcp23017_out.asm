;-------------------------------------------------------------------------------
; mcp23017_out - Output a byte to a port on the mcp23017 gpio with I2C
; using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
;
; Copyright 2023 Milton 'Nick' DeNicholas
;
; This is an extension of Copyrighted work by Gaston Williams
; please see https://github.com/fourstix/Elfos-I2C-Libraries for more info
;
; Based on the Elf-I2C library
; Written by Tony Hefner
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
#include ../../include/mcp23017_def.inc

;-------------------------------------------------------------------------------
; Write a byte (bit pattern) to an output port (A or B)
;    
; Example: 
;   The following writes a bit pattern to Bank/Port A or B
;           call    mcp23017_out       ; mcp23017 output set pins
;           db      MCP23017_BANKA     ; bank A = 0 ,  B = 1
;           db      $FF                ; bit pattern to output to port
;
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    mcp23017_out

            ghi     r7                 ; save working registers
            stxd
            glo     r7
            stxd
            ghi     r8
            stxd
            glo     r8
            stxd
            
            lda     r6                 ; get the bank we're dealing with
            phi     r7                 ; save it in r7.1 and ...
            mov     r8, (gpio5)         
            ldi     $12                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            sex     r8                 ; use X to point to command register
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; bump
            inc     r8                 ;    to pin pattern
            lda     r6                 ; get users pin pattern
            str     r8                 ;    and store in command buffer
            sex     r2                 ; reset x
            call    i2c_wrbuf          ; write to mcp23017 device gpio pins
            db      I2C_ADDR , $02     ;    where i2c addr for 2 bytes
            dw      gpio5              ; cmd message buffer
            
            irx                        ; restore registers
            ldxa
            plo     r8
            ldxa
            phi     r8
            ldxa
            plo     r7
            ldx
            phi     r7
            
            return                      ; DF = 0 on success, DF = 1 on error
                                    
; ---------- this storage is modified at run time, not romable ------------
            gpio5:      db    $12,$FF
                        
            endp
                        