;-------------------------------------------------------------------------------
; lcdchar - demo to show various character and cursor functions on a 
; Liquid Crystal Display with I2C using the PIO and I2C Expansion Boards
; for the 1802/Mini Computer.
;
; Copyright 2023 by Gaston Williams
;
; Based on program code in the Elf-I2C library
; Written by Tony Hefner
; Copyright 2023 by Tony Hefner
; Please see github.com/arhefner/Elfos-I2C for more info
;
; PIO and I2C Expansion Boards for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
; Please see github.com/arhefner/1802-Mini-PIO for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/lcd_lib.inc
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
            lda     ra                  ; get byte
            lbz     small               ; default is 16x2 display
            smi     '-'                 ; check for dash 
            lbnz    usage               ; anything but dash is an error
            lda     ra                  ; get next option
            smi     'l'                 ; check for 20x4 display (large)
            lbz     large
            smi     7                   ; 's'-'l' = 7
            lbnz    usage               ; anything else is an error

small:      ldi     0                   ; flag for small display
            plo     r7
            lbr     begin_demo
            
large:      ldi     $FF                 ; flag for large display
            plo     r7
                      
begin_demo: call    i2c_init            ; initialize i2c bus
            
            call    lcd_avail           ; check i2c bus for display
            lbdf    no_id               ; exit with error msg, if not found

            call    lcd_init            ; initialize display
            lbdf    errmsg

            load    rf, heart           ; create custom character
            ldi     0                   ; at index 0
            call    lcd_create_char
            lbdf    errmsg
            
            load    rf, smiley          ; create custom character
            ldi     1                   ; at index 1
            call    lcd_create_char
            lbdf    errmsg
                        
            ldi    'O'
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately
    
            ldi    'K'
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately

            call    lcd_cursor_on       ; set cursor on
            lbdf    errmsg
            
            load    rf, prompt          ; show input prompt
            call    o_msg
            
            bn4     $                   ; wait for key press
            b4      $                      
                                                   
            ; move cursor to column 3, line 0 (first line)
            ldi     3                   ; column 3
            phi     rd
            ldi     0                   ; row 0 (first line)
            plo     rd
            call    lcd_position        ; position cursor at col 3, row 0
            lbdf    errmsg

            ; print a test message at line 0  (first line)
            load    rf, test_msg
            call    lcd_print_str
            lbdf    errmsg

            call    lcd_cursor_off       ; set cursor off
            lbdf    errmsg
                        
            call    lcd_blink_on        ; set blink on
            lbdf    errmsg
                        
            ; move cursor to column 8, line 1 (second line)
            ldi     6                   ; column 6
            phi     rd
            ldi     1                   ; row 1 (second line)
            plo     rd
            
            call    lcd_position        ; position cursor at col 6, row 1
            lbdf    errmsg
            
            
            load    rf, test_msg
            ldi     5                   ; print only 5 characters of test msg
            plo     rc
            call    lcd_print_nstr      ; print n characters of string
            lbdf    errmsg            

            bn4     $                   ; wait for key press
            b4      $

            call    lcd_blink_off       ; set blink off
            lbdf    errmsg

            glo     r7                  ; check the display size flag
            lbnz    large1              ; don't clear a 20x4 display

            call    lcd_default         ; clear display
            lbdf    errmsg            

            call    lcd_clear 
            lbdf    errmsg

            call    lcd_home
            lbdf    errmsg

            lbr     show1
            
            ; move cursor to column 5, row 2 (third line) on a 20x4 display
large1:     ldi     5                   ; column 5
            phi     rd
            ldi     2                   ; row 2 (third line)
            plo     rd
            call    lcd_position        ; position cursor at col 5, row 2
            lbdf    errmsg

show1:      ldi     'I'
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately
    
            ldi     ' '
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately

            ldi     $00                 ; index for heart custom character
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately

            load    rf, elf_msg         ; print rest of string
            call    lcd_print_str 
            lbdf    errmsg              ; if error, exit immediately   

            glo     r7                  ; get the display size flag
            lbnz    large2        
            
            ; move cursor to column 0, line 1 (second line)
            ldi     0                   ; column 0
            phi     rd
            ldi     1                   ; row 1 (second line)
            plo     rd
            call    lcd_position        ; position cursor at col 0, row 1
            lbdf    errmsg
            lbr     show2               ; show the next line

            
large2:     ; move cursor to column 3, row 3 (fourth line) on a 20x4 display
            ldi     3                   ; column 3
            phi     rd
            ldi     3                   ; row 3 (fourth line)
            plo     rd
            call    lcd_position        ; position cursor at col 3, row 3
            lbdf    errmsg

show2:      ldi     $01                 ; index for smiley custom character
            call    lcd_print_char
            lbdf    errmsg              ; if error, exit immediately
            
            load    rf, bye_msg
            call    lcd_print_str   
            lbdf    errmsg              ; if error, exit immediately  
            
            ldi     $01                 ; index for smiley custom character
            call    lcd_print_char
            lbdf    errmsg               
            
            bn4     $                   ; wait for input
            b4      $
            
            call    lcd_display_off     ; turn off display
            lbdf    errmsg
            
            call    lcd_backlight_off   ; turn off backlight
            lbdf    errmsg
                                      
done:       ldi     0
            return                      ; return to Elf/OS

test_msg:   db 'Hello, World!',0        ; test message                      

heart:      db  $00, $0a, $1f, $1f, $0e, $04, $00, $00

smiley:     db  $00, $00, $0a, $00, $00, $11, $0E, $00

bye_msg:    db  ' Good-bye! ',0


elf_msg:    db ' 1802',0

prompt:     db 'Press Input to continue the demo.',10,13,0

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code

            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: lcdchar [-s|-l] (default = -s, 16x2 display)',10,13,0
            call    o_inmsg             ; otherwise display usage message
            db      'Options: -l = large 20x4 display; -s = small 16x2 display',10,13,0                        
            abend                       ; and return to os with error code

            end     start
