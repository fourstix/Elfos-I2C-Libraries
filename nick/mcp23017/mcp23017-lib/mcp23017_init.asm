;-------------------------------------------------------------------------------
; mcp23017_init - Routine to initialize the MCP23017 GPIO Chip, allows for user 
; to pass params. Assumes device connected to the PIO and I2C Expansion Boards 
; for the 1802/Mini Computer.
;
; Copyright 2023 Milton 'Nick' DeNicholas
;
; This is an extension of Copyrighted work by Gaston Williams
; please see https://github.com/fourstix/Elfos-I2C-Libraries for more info
;
; Based on the the Elf-I2C library
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
; Initialize the I2C gpio chip, initialization params follow call. Three types of 
; initialization are supported, All port(s) as an INPUT or port(s) as an OUTPUT,
; or a mixed set of inputs and outputs on any port.
;
; Port as all OUTPUT Parameters:
;   1: bank            A = 00, B = 01 (1 byte)
;   2: In/Out          sets all pins on port to output ($00) (1 byte) 
;
; Example:
;   This call inits the gpio port A on an mcp23017 i2c device at 
;   address I2C_ADDR in mcp23017_def.inc as all outputs. Function recognizes that
;   all pins are outputs and does not expect the last 2 params:
;
;   gpio_init:  call    mcp23017_init       ; init and set params of mcp23017
;               db      MCP23017_BANKA      ; bank A = 0 ,  B = 1
;               db      MCP23017_OUTPUTS    ; data pins are all output
;
;
; Port as all INPUT Parameters:
;   1: bank            A = 00, B = 01 (1 byte)
;   2: In/Out          sets all pins on port to input ($FF) (1 byte) 
;   3: Pullups         Enable pullups ($FF) Disable ($00) (1 byte) 
;   4: Polarity        Invert sense of input ($FF) Normal sense ($00) (1 byte) 
;
; Example:
;   This call inits the gpio port B on an mcp23017 i2c device at 
;   address I2C_ADDR in mcp23017_def.inc as all inputs:
;
;   gpio_init:  call    mcp23017_init       ; init and set params of mcp23017
;               db      MCP23017_BANKB      ; bank A = 0 ,  B = 1
;               db      MCP23017_INPUTS     ; data pins are all input
;               db      MCP23017_EN_PUR     ; enable or disable Pull Up resistors
;               db      MCP23017_IN-NORM    ; normal or invert polarity of inputs
;
;
; Port as mixed INPUT/OUTPUT Parameters:
;   1: bank            A = 00, B = 01 (1 byte)
;   2: In/Out          1=input, 0=output x 8 pins (1 byte) 
;   3: Pullups         1=Enable, 0=No Pullup x 8 pins (1 byte) 
;   4: Polarity        1=Invert, 0=Normal x 8 pins (1 byte) 
;
; Example:
;   This call inits the gpio port A on an mcp23017 i2c device at 
;   address I2C_ADDR in mcp23017_def.inc as mixed inputs/outputs:
;
;   gpio_init:  call    mcp23017_init       ; init and set params of mcp23017
;               db      MCP23017_BANKA      ; bank A = 0 ,  B = 1
;               db      0b10001100          ; data pins are mixed in/out
;               db      0b00000100          ; 1=enable or 0=disable Pull Ups
;               db      0b00000100          ; 0=normal or 1=invert input polarity
; 
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    mcp23017_init
            
            ghi     r7
            stxd
            glo     r7
            stxd
            ghi     r8
            stxd
            glo     r8
            stxd
            
            ldi     $00                ; init R7.0 to say output init only
            plo     r7                 ;
            lda     r6                 ; get the bank we're dealing with
            phi     r7                 ; save it in r7.1 and ...
            mov     r8, (gpio1)         
            ldi     $0A                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            sex     r8                 ; use X to point to command register
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; bump
            inc     r8                 ;    to next 
            inc     r8                 ;        cmd register
            ldi     $00                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; bump to next
            inc     r8                 ;       user parameter
            lda     r6                 ; get parameter inputs (FF) outputs (00)
            str     r8                 ; store user param in command string
            lbz     initout            ; if init as output were done
            inc     r8                 ; bump to next register in command
            ldi     $0C                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; bump to next
            inc     r8                 ;       user parameter
            lda     r6                 ; Enable Pull Up resistors (FF) disable (00)
            str     r8                 ; store user param in command string
            inc     r8                 ; bump to next register in command
            ldi     $02                ; assume bank A cmnds
            str     r8                 ; store register in cmd buffer
            ghi     r7                 ; get users bank request A=0 B=1
            add                        ; add bank to register in command
            str     r8                 ; bump to next
            inc     r8                 ;       user parameter
            lda     r6                 ; normal or invert polarity of inputs
            str     r8                 ; store user param in command string
            ldi     $01                ; flag that were doing input init !
            plo     r7

initout:
            sex     r2                 ; reset x
            call    i2c_wrbuf          ; init for IOCON = Bank=0, sequential
            db      I2C_ADDR , $02     ;    where i2c addr for 2 bytes
            dw      gpio1              ; cmd message buffer
            lbdf    init_fin
            call    i2c_wrbuf          ; write to mcp23017 device input/output
            db      I2C_ADDR , $02     ;    where i2c addr = $20  for 2 bytes
            dw      gpio2              ; cmd message buffer
            lbdf    init_fin
            glo     r7                 ; check if we're doing input initalization?
            lbz     init_fin           ; if not were out a here ....
            call    i2c_wrbuf          ; write to mcp23017 device en/dis pullups
            db      I2C_ADDR , $02     ;    where i2c addr = $20  for 2 bytes
            dw      gpio3              ; cmd message buffer
            lbdf    init_fin
            call    i2c_wrbuf          ; write to mcp23017 device input polarity
            db      I2C_ADDR , $02     ;    where i2c addr = $20  for 2 bytes
            dw      gpio4              ; cmd message buffer
            clc
init_fin:
            irx                        ; restore registers
            ldxa
            plo     r8
            ldxa
            phi     r8
            ldxa
            plo     r7
            ldx
            phi     r7
            return                     ; DF = 0 on success, DF = 1 on error

; ---------- this storage is modified at run time, not romable ------------
gpio1:      db      $0A,$20            ; IOCON cmds to sequential
gpio2:      db      $00,$00            ; port direction input/output
gpio3:      db      $0C,$00            ; input pull up resistor enable / disable
gpio4:      db      $02,$00            ; input polarity, normal or inverted
          
            endp
            