;-------------------------------------------------------------------------------
; mcp23017_set_pin - Set a specific pin in a port on the mcp23017 gpio with I2C
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
#include ../../include/mcp23017_lib.inc
#include ../../include/mcp23017_def.inc

;-------------------------------------------------------------------------------
; Set a pin to 1/0 on any gpio output port (A or B)
;    
; Example: 
;   The following sets the 5th pin in Bank/Port B to 0
;           call    mcp23017_set_pin   ; mcp23017 set a specific pin to 1/0
;           db      MCP23017_BANKB     ; bank A = 0 ,  B = 1
;           db      $10                ; set state of 5th pin (80,40,20,10,08 .. 01)
;           db      $00                ; state to set 1/0;
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    mcp23017_set_pin

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
            phi     rb                 ; save it in rb.1 and ...
            mov     r8, gpioS         
            ldi     $12                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            sex     r8                 ; use X to point to command register
            ghi     rb                 ; get users bank request A=0 B=1
            add                        ;    add bank to register in command
            str     r8                 ; save register in cmc buffer
                        
            lda     r6                 ; get pin number/mask (80,40,20,10,08 .. 01)
            phi     r7                 ; r7.1 holds the pin mask of pin to set
            
            lda     r6                 ; get state to set (0-a)
            plo     r7                 ; r7.0 holds the pin state requested
                        
            mov     r8, bank           ; modify command to bank we're working with
            ghi     rb                 ;    using the
            str     r8                 ;       bank passed above
            inc     r8                 ; bump to command
            add                        ;    add bank to register in command
            str     r8
            sex     r2                 ; reset x
                        
            call    mcp23017_read      ; read any register's current status
bank:       db      MCP23017_BANKA     ; Bank
            db      MCP23017_GPIO      ; Read GPIO Port/Register into ...
            dw      gpioS + 1          ; put port status into message buffer
            lbdf    set_err
                        
            mov     r8, gpioS + 1      ; point at status in next cmd buffer
            sex     r8
            glo     r7                 ; are we setting (1) or clearing (0)?
            lbz     clearpin
            ghi     r7                 ; get pin mask
            or                         ;   or it with current status, sets pin
            str     r8
            lbr     run_cmd            ; go write updated port byte 
clearpin:
            ghi     r7                 ; get the pin mask
            xri     $FF                ;   get it's complement
            and                        ;      and it with current status
            str     r8                 ;         which clears the pin if it was 1
run_cmd:
            sex     r2
            call    i2c_wrbuf          ; write to mcp23017 device gpio pins
            db      I2C_ADDR , $02     ;    where i2c addr for 2 bytes
            dw      gpioS              ; address of cmd message buffer  
set_err:
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
gpioS:      db      $12,$00
            
            
            endp
                        