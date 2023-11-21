;-------------------------------------------------------------------------------
; mcp23017_get_pin - Get a specific pin's status from a port on the mcp23017 gpio 
; with I2C using the PIO and I2C Expansion Boards for the 1802/Mini Computer.
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
; Get a pins current status 1/0 from any gpio output port (A or B)
;    
; Example: 
;   The following reads the current status from 8th bit on Bank/Port A
;           call    mcp23017_get_pin   ; mcp23017 get a specific pin to 1/0
;           db      MCP23017_BANKA     ; bank A = 0 ,  B = 1
;           db      $80                ; set state of 8th pin (80,40,20,10,08 .. 01)
;           dw      pin_state          ; where the state will be stored on return
;
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    mcp23017_get_pin

            ghi     r7                 ; save working registers
            stxd
            glo     r7
            stxd
            ghi     r8
            stxd
            glo     r8
            stxd
            ghi     rb
            stxd
            glo     rb
            stxd
                        
            lda     r6                 ; get the bank we're dealing with
            phi     r7                 ; save it in r7.1 and ...
            mov     r8, get_reg         
            ldi     $12                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            sex     r8                 ; use X to point to command register
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; save register in call params
                        
            lda     r6                 ; get pin number/mask (80,40,20,10,08 .. 01)
            phi     r7                 ; r7.1 holds the pin mask to get pin state
                        
            lda     r6                 ; get users storage addr high
            phi     rb                 ; rb points to where user wants
            lda     r6                 ;    the bit state stored
            plo     rb
                        
            sex     r2                 ; reset x
            call    i2c_rdreg          ; read from mcp23017 device gpio pins
            db      I2C_ADDR           ;    at i2c addr
            db      $01                ; bytes to write = 1
get_reg:    db      $12                ; register to read from (~altered at run time)
            db      $01                ; bytes to read = 1
            dw      get_buf            ; location to save the read byte
            lbdf    get_err
            mov     r8, get_buf
            sex     r8                 ; set up for AND
            ghi     r7                 ; get mask
            and                        ; D is Non Zero if bit was 1, Zero if 0
            str     rb                 ; put result where user asked for it to go
            clc                        ; indicate sucess
            sex     r2
get_err:
            irx                        ; restore registers
            ldxa
            plo     rb
            ldxa
            phi     rb
            ldxa
            plo     r8
            ldxa
            phi     r8
            ldxa
            plo     r7
            ldx
            phi     r7
                        
            return
                        
; ---------- this storage is modified at run time, not romable ------------
get_buf:   dw      $00
            
            
            endp
                        