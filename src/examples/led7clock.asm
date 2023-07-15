;-------------------------------------------------------------------------------
; led7clock - a demo program for displaying the time on an Adafruit 4 digit 
; 7-segment display with I2C using the PIO Expansion Board for the 
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
; Adafruit 4 Digit 7-Segment Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/led7_lib.inc
#include ../include/i2c_lib.inc


#define RTC_REG         20h

#define CLEAR_INT       10h

#define RATE_64HZ       10h
#define RATE_1_PER_SEC  14h
#define RATE_1_PER_MIN  18h
#define RATE_1_PER_HR   1ch

#define INT_ENABLE      10h
#define INT_MASK        11h

#define PULSE_MODE      10h
#define INT_MODE        12h

#define RTC_INT_ENABLE  41h
#define RTC_INT_DISABLE 40h


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
            lbz     clock               ; jump if no argument given
            call    o_inmsg             ; otherwise display usage message
            db      'Usage: led7clock',10,13,0
            ldi     $0a
            rtn                         ; and return to os

clock:      call    o_inmsg             ; display greeting
            db      'LED Clock',10,13,0
            
            call    i2c_init            ; initialize i2c bus
            
            call    led7_avail          ; check for device
            lbdf    no_id               ; if not found, exit program
            
            call    led7_init           ; set up display
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    led7_set_blink_off  ; turn off blinking
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    led7_set_brightness ; set brightness
            lbdf    errmsg              ; if error writing to device, exit with msg

            mov     r1, introu          ; set up interrupt handler routin

            ldi     1
            plo     r8

            sex     r3

          #if RTC_GROUP != I2C_GROUP
            out     EXP_PORT
            db      RTC_GROUP
          #endif

            out     RTC_PORT
            db      RTC_REG | 0eh
            out     RTC_PORT
            db      RATE_1_PER_SEC | INT_MODE | INT_ENABLE

            out     RTC_PORT
            db      RTC_INT_ENABLE

          #if RTC_GROUP
            out     EXP_PORT              ; make sure default expander group
            db      NO_GROUP
          #endif

            ret                           ; return and enable interrupts
            db      23h                   ; return sets X=2, P=3 

wait:       bn4     test
            lbr     done
test:       glo     r8
            bnz     wait

            ldi     1
            plo     r8

            mov     rf, time_buf
            call    o_gettod

            mov     rf, time_buf+3

            ldn     rf
            bz      hr12
            smi     12
            bz      hr12
            bge     disphr
            ldn     rf
            lskp

hr12:       ldi     12

disphr:     plo     rc
            mov     rf, bcd_buf
            call    led7_tobcd

            ldi     0
            plo     ra
            mov     rf, tens
            ldn     rf
            bz      lead0
            plo     rb
            call    led7_write_digit
            lskp

lead0:      call    led7_write_blank      

disphr1:    mov     rf, ones
            ldn     rf
            plo     rb
            ldi     1
            plo     ra
            call    led7_write_digit

            mov     rf, time_buf+4

            ldn     rf
            plo     rc
            mov     rf, bcd_buf
            call    led7_tobcd

            mov     rf, tens
            ldn     rf
            plo     rb
            ldi     2
            plo     ra
            call    led7_write_digit

            mov     rf, ones
            ldn     rf
            plo     rb
            ldi     3
            plo     ra
            call    led7_write_digit

            mov     rf, time_buf+5

            ldn     rf
            plo     rb
            call    led7_write_colon

            call    led7_write_disp     ; update the display
            lbdf    done                ; if update fails, exit program

            lbr     wait


done:       sex     r3      ; turn off interrupt handling immediately
            dis             ; return and disable interrupts
            db      23h     ; set X=2, P=3
            
            
            ;------ set the RTC interupt off
            sex     r3
            
          #if RTC_GROUP
            out     EXP_PORT
            db      RTC_GROUP
          #endif

            out     RTC_PORT
            db      RTC_INT_DISABLE
            out     RTC_PORT
            db      INT_MASK
            out     RTC_PORT
            db      CLEAR_INT

            ;---- blank the display and set group back to default
            sex     r2
            call    led7_blank_disp
            sex     r3
              
          #if RTC_GROUP
            out     EXP_PORT              ; make sure default expander group
            db      NO_GROUP
          #endif

            sex     r2

            ldi     0
            return                      ; return to Elf/OS

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

time_buf:   ds      10
bcd_buf:    ds      1
tens:       ds      1
ones:       ds      1
            
            ;---- interrupt handler routine
  
; .align      page

exiti:      ret

introu:     dec     r2
            sav
            dec     r2
            stxd
            shrc
            stxd

            sex     r1

          #if RTC_GROUP
            out     EXP_PORT                ; make sure default expander group
            db      RTC_GROUP
          #endif

            out     RTC_PORT
            db      RTC_REG | 0dh
            out     RTC_PORT
            db      CLEAR_INT

          #if RTC_GROUP
            out     EXP_PORT              ; make sure default expander group
            db      NO_GROUP
          #endif

            sex     r2

            dec     r8

exit:       inc     r2
            lda     r2
            shl
            lda     r2
            lbr     exiti     

            end     start
