;-------------------------------------------------------------------------------
; joystick - a demo program to read information from a Sparkfun   
; Qwiic Joystick with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
;
; Based on the osclock program in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Sparkfun Qwiic Single Relay
; Copyright 2019-2023 by Sparkfun Electronics
; Please see https://www.sparkfun.com/products/15093 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/joystick_lib.inc
#include ../include/i2c_lib.inc

            org     2000h
start:      br      main


            ; Build information

            ever

            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument

main:       lda     ra                  ; move past any spaces
            smi     ' '
            lbz     main
            dec     ra                  ; move back to non-space character
            ldn     ra                  ; get byte
            lbnz    usage               ; jump if any argument given
                        
            call    i2c_init            ; initialize i2c bus
            
            call    joystick_avail      ; check i2c bus for joystick
            lbdf    no_id               ; exit with error msg, if not found

            ; get the x location
            call    joystick_get_horizontal
            lbdf    errmsg
          
            load    rf, x_buff          ; convert y to integer string
            call    f_intout

            ; get the y location
            call    joystick_get_vertical
            lbdf    errmsg
          
            load    rf, y_buff          ; convert y to integer string
            call    f_intout

            ; get the x msb
            call    joystick_get_x_byte
            lbdf    errmsg
          
            plo     rd                  ; save byte for string conversion  
            load    rf, x_hex           ; convert x byte to hex string
            call    f_hexout2

            ; get the y msb
            call    joystick_get_y_byte
            lbdf    errmsg
            
            plo     rd
            load    rf, y_hex          ; convert y byte to hex string
            call    f_hexout2

            ; get the xy position
            call    joystick_get_xy_position
            lbdf    errmsg
            
            load    rf, pos_hex         ; convert x,y bytes in rd to hex string
            call    f_hexout4

            ; get the button state
            call    joystick_button_state
            lbdf    errmsg

            plo     rd                  ; save state byte for string conversion  
            load    rf, state_hex       ; convert x byte to hex string
            call    f_hexout2

            ; get the button pressed flag
            call    joystick_button_pressed
            lbdf    errmsg

            plo     rd                  ; save pressed byte for string conversion  
            load    rf, press_hex       ; convert pressed byte to hex string
            call    f_hexout2
              
            ; get the joystick version string
            call    joystick_get_version  ; rf points to version string
            lbdf    errmsg

            call    o_inmsg             ; print firmware label
            db 'Joystick ',0

            call    o_msg               ; print version string in rf

            call    o_inmsg             ; print eol
            db 10,13,0      
                       
            call    o_inmsg             ; print x label
            db 'X: ',0

            load    rf, x_buff          ; print x value
            call    o_msg

            call    o_inmsg             ; print y label
            db ' Y: ',0
            
            load    rf, y_buff          ; print y value
            call    o_msg

            call    o_inmsg             ; print eol
            db 10,13,0      
            
            call    o_inmsg
            db      'Byte X: ',0

            load    rf, x_hex          ; print x msb value
            call    o_msg

            call    o_inmsg
            db      ' Byte Y: ',0

            load    rf, y_hex          ; print y msb value
            call    o_msg
            
            call    o_inmsg             ; print eol
            db 10,13,0      

            call    o_inmsg
            db      'Position [Y:X] = ',0

            load    rf, pos_hex          ; print x msb value
            call    o_msg

            call    o_inmsg             ; print eol
            db 10,13,0      
            
            call    o_inmsg
            db      'Button = ',0

            load    rf, state_hex        ; print button state (Up or Down)
            call    o_msg
            
            call    o_inmsg
            db      ', Pressed = ',0

            load    rf, press_hex        ; print button pressed flag
            call    o_msg

            call    o_inmsg             ; print eol
            db 10,13,0      
            
            
done:       ldi     0
            return                      ; return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            

usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: joystick',10,13,0
            abend                       ; and return to os with error code

x_buff:     db 0,0,0,0,0,0              ; buffer for x int string            
y_buff:     db 0,0,0,0,0,0              ; buffer for y int string           
x_hex:      db 0,0,0                    ; buffer for x byte hex string
y_hex:      db 0,0,0                    ; buffer for y byte hex string
pos_hex:    db 0,0,0,0,0                ; buffer for xy position hex string
state_hex:  db 0,0,0                    ; buffer for button state hex string
press_hex:  db 0,0,0                    ; buffer for button pressed hex string
            end     start
