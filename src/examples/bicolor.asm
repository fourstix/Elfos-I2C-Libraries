;-------------------------------------------------------------------------------
; bicolor - a demo program for an Adafruit Bicolor 8x8 LED matrix 
; display with I2C using the PIO and I2C Expansion Boards for the 
; 1802/Mini Computer.
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; The 1802-Mini Computer hardware
; Copyright (c) 2021-2022 by David Madole
; Please see github.com/dmadole/1802-Mini for more info.
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;
; Adafruit 8x8 LED Matrix and Bi-Color LED Matrix Display hardware
; Copyright 2012-2023 by Adafruit Industries
; Please see learn.adafruit.com/adafruit-led-backpack/ for more info
;-------------------------------------------------------------------------------


#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/ht16k33_def.inc  
#include ../include/mtrx_lib.inc
#include ../include/util_lib.inc
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
                        
            
show_it:    call    i2c_init            ; initialize i2c bus

            call    mtrx_avail          ; check for display
            lbdf    no_id               ; if not found, exit program
            
            call    mtrx_init           ; set up display
            lbdf    errmsg              ; if error writing to device, exit with msg

            call    mtrx_blink_off      ; turn off blinking
            lbdf    errmsg              ; if error writing to device, exit with msg

            ldi     10                  ; medium bright
            plo     rb
            call    mtrx_brightness     ; set brightness
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ;---- draw pixels
            ldi     3                   ; set up counter 
            plo     rc        


            ldi     0                   ; set pixel position at 0,0
            plo     r7                  ; set pixel x
            phi     r7                  ; set pixel y
            ldi     LED_GREEN           
            phi     r9                  ; set pixel color
            
loop:       call    mtrx_draw_pixel     ; draw pixel in buffer
            
            ghi     r7                  ; get signed y value
            adi      1                  ; add one
            phi     r7                  ; update y

            glo     r7                  ; get signed x value
            adi      1                  ; add one
            plo     r7                  ; update x
                        
            dec     rc                  ; count down
            glo     rc                  ; check counter
            bnz     loop                ; keep going for 3 pixels
            
            ldi     3                   ; set pixel position at 3,3
            plo     r7                  ; set pixel x
            phi     r7                  ; set pixel y
            ldi     LED_YELLOW           
            phi     r9                  ; set pixel color            
            call    mtrx_draw_pixel     ; draw pixel in buffer

            ldi     4                   ; set pixel position at 4,4
            plo     r7                  ; set pixel x
            phi     r7                  ; set pixel y
            call    mtrx_draw_pixel     ; draw pixel in buffer
            
            
            ldi     3                   ; reset counter 
            plo     rc        
            
            ldi     5                   ; set pixel position at 5,5
            plo     r7                  ; set pixel x
            phi     r7                  ; set pixel y
            ldi     LED_RED           
            phi     r9                  ; set pixel color

loop2:      call    mtrx_draw_pixel     ; draw pixel in buffer
            
            ghi     r7                  ; get signed y value
            adi      1                  ; add one
            phi     r7                  ; update y

            glo     r7                  ; get signed x value
            adi      1                  ; add one
            plo     r7                  ; update x
                        
            dec     rc                  ; count down
            glo     rc                  ; check counter
            bnz     loop2               ; keep going for 3 pixels
      
            ;---- update display to show pixels
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay
            
            ;---- clear display and draw rectangles
            call    mtrx_clear          ; clear display

            ldi     LED_RED             ; set color
            phi     r9
            
            ldi     0                   ; set rectangle origin
            plo     r7
            phi     r7
            
            ldi     8                   ; set dimensions
            plo     r8                  ; set width
            phi     r8                  ; set height
            
            call    mtrx_draw_rect      ; draw rectangle
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ;---- update display to show rectangle
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay

            ldi     LED_GREEN           ; set color
            phi     r9
            
            ldi     1                   ; set rectangle origin
            plo     r7                  ; x = 1
            phi     r7                  ; y = 1
            
            ldi     6                   ; set dimensions
            plo     r8                  ; set width
            phi     r8                  ; set height
            
            call    mtrx_fill_rect      ; draw rectangle
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ;---- update display to show rectangles
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay

            ;---- clear display and straight lines            
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg  


            ;---------------------------------------------------------------------
            ; Draw horizontal and veritcal lines 
            ;---------------------------------------------------------------------
            ; draw a horizontal line from 0,0 to 7,0
            ldi     0                   ; set line origin at 0,0
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y
            
                                        ; set line origin at 7,0
            phi     r8                  ; set endpoint y = 0
            ldi     7
            plo     r8                  ; set endpoint x = 7
            
            ldi     LED_GREEN           
            phi     r9                  ; set pixel color
            
            call    mtrx_draw_line     ; draw line in buffer
            
            ; test drawing horizontal line with swapped endpoints 
            ldi     5                   ; set line origin at 5,5
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y

            ; set line endpoint at 2,5
            phi     r8                  ; set endpoint y = 5
            ldi     2                    
            plo     r8                  ; set endpoint x = 2            
            ldi     LED_YELLOW           
            phi     r9                  ; set line color            
            call    mtrx_draw_line      ; draw line in buffer

            ; draw a vertical line from 1,1 to 1,6
            ldi     1                   ; set line origin at 1,1
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y
                                        
            ; set line endpoint at 1, 6
            plo     r8                  ; set line endpoint at 1, 6
            ldi     6
            phi     r8                  ; set endpoint y
            
            ldi     LED_RED           
            phi     r9                  ; set pixel color            
            call    mtrx_draw_line      ; draw line in buffer   
            
            ; test drawing vertical line with swapped endpoints
            ldi     5                   ; set line origin at 5,5
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y
            
            ; set line endpoint at 1, 5
            plo     r8                  ; set line endpoint at 5,1
            ldi     1
            phi     r8
            ldi     LED_GREEN           
            phi     r9                  ; set pixel color

            call    mtrx_draw_line      ; draw pixel in buffer
                
            ;---- update display to show lines
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay

            ;-------------------------------------------------------------------
            ; Draw slanted lines with  (x1-x0) >= (y1-y0)
            ;-------------------------------------------------------------------
            
            ;---- clear display         
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
              
              
            ; draw a slanted line from 0,0 to 7,7
            ldi     0                   ; set line origin at 0,0
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y
            
            ldi     7                   ; set line endpoint at 7,7
            phi     r8                  ; set endpoint y = 0
            plo     r8                  ; set endpoint x = 7
            
            ldi     LED_GREEN           
            phi     r9                  ; set pixel color
            
            call    mtrx_draw_line     ; draw line in buffer
            
            ; test drawing slanted line with swapped endpoints 
            ldi     5                   ; set line origin at 5,7
            plo     r7                  ; set origin x
            ldi     7
            phi     r7                  ; set origin y

            ; set line endpoint at 0,3
            ldi     0
            plo     r8                  ; set endpoint x = 0            
            ldi     3                    
            phi     r8                  ; set endpoint y = 3
            ldi     LED_YELLOW           
            phi     r9                  ; set line color            
            call    mtrx_draw_line      ; draw line in buffer

            call    mtrx_write_disp     ; update display
            lbdf    errmsg  
            
            load    rc, DELAY_500MS
            call    util_delay


            ;---- clear display and draw slanted lines         
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
              
              
            ; draw a slanted line from 0,7 to 7,0
            ldi     0                   ; set line origin at 0,7
            plo     r7                  ; set origin x
                                        ; set line endpoint at 7,0
            phi     r8                  ; set endpoint y = 0

            ldi     7
            phi     r7                  ; set origin y
            plo     r8                  ; set endpoint y = 0
            
            ldi     LED_RED           
            phi     r9                  ; set pixel color
            
            call    mtrx_draw_line     ; draw line in buffer
            
            ; test drawing slanted line with swapped endpoints 
            ldi     6                   ; set line origin at 6,4
            plo     r7                  ; set origin x
            ldi     4
            phi     r7                  ; set origin y

            ; set line endpoint at 1,7
            ldi     1
            plo     r8                  ; set endpoint x = 1            
            ldi     7                    
            phi     r8                  ; set endpoint y = 7
            ldi     LED_YELLOW           
            phi     r9                  ; set line color            
            call    mtrx_draw_line      ; draw line in buffer

            call    mtrx_write_disp     ; update display
            lbdf    errmsg  
            
            load    rc, DELAY_500MS
            call    util_delay

            ;-------------------------------------------------------------------
            ; Draw steep slanted lines with  (y1-y0) > (x1-x0)
            ;-------------------------------------------------------------------
            
            ;---- clear display and draw steep lines        
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
              
              
            ; draw a slanted line from 1,1 to 2,7
            ldi     1                   ; set line origin at 1,1
            plo     r7                  ; set origin x
            phi     r7                  ; set origin y
            
                                        ; set line endpoint at 2,7
            ldi     2
            plo     r8                  ; set endpoint x = 2
            ldi     7                   
            phi     r8                  ; set endpoint y = 7
            
            ldi     LED_YELLOW          
            phi     r9                  ; set pixel color
            
            call    mtrx_draw_line     ; draw line in buffer
            
            ; test drawing steep slanted line with swapped endpoints 
            ldi     4                   ; set line origin at 4,7
            plo     r7                  ; set origin x
            ldi     7
            phi     r7                  ; set origin y

            ; set line endpoint at 7,0
            ldi     7
            plo     r8                  ; set endpoint x = 0            
            ldi     0                    
            phi     r8                  ; set endpoint y = 3
            ldi     LED_RED           
            phi     r9                  ; set line color            
            call    mtrx_draw_line      ; draw line in buffer

            call    mtrx_write_disp     ; update display
            lbdf    errmsg  
            
            load    rc, DELAY_500MS
            call    util_delay
              
            ;---- clear display and draw bitmaps             
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
          
            load    rf, triangle         ; load test bitmap
            ldi     LED_RED
            phi     r9                  ; set bitmap color

            ldi     0                   ; set origin (upper left corner) to 0,0  
            plo     r7                  ; set origin x to 0
            phi     r7                  ; set origin y to 0
            
            ldi     8                   ; set bitmap dimensions to 8x8
            plo     r8                  ; set bitmap width
            phi     r8                  ; set bitmap height

            call    mtrx_draw_bitmap
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ;---- update display to show bitmap
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay
            
            ;---- clear display and draw bitmap              
            call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
          
            load    rf, frown           ; load test bitmap (clipped)
            ldi     LED_YELLOW
            phi     r9                  ; set bitmap color

            ldi     -2                  ; set origin (upper left corner)  
            plo     r7                  ; set origin x to -2 (clipped bitmap)
            phi     r7                  ; set origin y to -2 (clipped bitmap)

            ldi     8                   ; set bitmap dimensions to 8x8
            plo     r8                  ; set bitmap width
            phi     r8                  ; set bitmap height
            
            call    mtrx_draw_bitmap
            lbdf    errmsg              ; if error writing to device, exit with msg

            ;---- update display to show bitmap
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
                    
            load    rc, DELAY_500MS
            call    util_delay

            call    mtrx_clear          ; clear display buffer
            lbdf    errmsg              ; if error writing to device, exit with msg

            load    rf, meh             ; load test bitmap (clipped)
            ldi     LED_RED
            phi     r9                  ; set bitmap color

            ldi     1                   ; set origin (upper left corner)  
            plo     r7                  ; set origin x to 1 (clipped bitmap)
            phi     r7                  ; set origin y to 1 (clipped bitmap)

            ldi     8                   ; set bitmap dimensions to 8x8
            plo     r8                  ; set bitmap width
            phi     r8                  ; set bitmap height            

            call    mtrx_draw_bitmap
            lbdf    errmsg              ; if error writing to device, exit with msg

            ;---- update display to show bitmap
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg

            load    rc, DELAY_500MS
            call    util_delay

            call    mtrx_clear          ; clear display buffer
            lbdf    errmsg              ; if error writing to device, exit with msg
          
            load    rf, smile           ; load test bitmap
            ldi     LED_GREEN
            phi     r9                  ; set bitmap color

            ldi     0                   ; set origin (upper left corner) to 0,0  
            plo     r7                  ; set origin x to 0
            phi     r7                  ; set origin y to 0

            ldi     8                   ; set bitmap dimensions to 8x8
            plo     r8                  ; set bitmap width
            phi     r8                  ; set bitmap height            

            call    mtrx_draw_bitmap
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ;---- update display to show bitmap
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            load    rc, DELAY_500MS
            call    util_delay
            
            call    mtrx_clear          ; clear display

            load    rf, tst_str1        ; print a test string
            ldi     LED_RED             ; set color
            phi     r9
            
            call   mtrx_print_hstr
            lbdf   errmsg               ; if error writing to device, exit with msg

            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg

            load    rc, DELAY_500MS
            call    util_delay
            
            call    mtrx_clear          ; clear display
            lbdf    errmsg              ; if error writing to device, exit with msg

            load    rf, tst_str2        ; print a test string
            ldi     LED_YELLOW          ; set color
            phi     r9
            
            call   mtrx_print_vstr
            lbdf   errmsg               ; if error writing to device, exit with msg

            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg

            load    rc, DELAY_500MS
            call    util_delay
            
            ;---- clear display and exit            
done:       call    mtrx_clear          ; clear display
            call    mtrx_write_disp     ; update display
            lbdf    errmsg              ; if error writing to device, exit with msg
            
            ldi     0
            return                      ; return to Elf/OS
            
no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: bicolor',10,13,0
            abend                       ; and return to os
            
            
            ;---- 8x8 bitmaps for testing
triangle:   db $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF
smile:      db $3c, $42, $a5, $81, $a5, $99, $42, $3c
meh:        db $3c, $42, $a5, $81, $bd, $81, $42, $3c 
frown:      db $3c, $42, $a5, $81, $99, $a5, $42, $3c            
            
            ;---- Strings for scrolling text
tst_str1:   db 'Hello,',0
tst_str2:   db 'World!',0
            end     start
