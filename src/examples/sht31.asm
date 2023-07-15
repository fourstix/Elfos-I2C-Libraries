;-------------------------------------------------------------------------------
; sht31test - a demo program to read an SHT31 Temperature and Humidity  
; sensor with I2C using the PIO Expansion Board for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
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
; Adafruit SHT31 Temperature & Humidity Sensor
; Copyright 2019-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/2857 for more info
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/sysconfig.inc
#include ../include/sht31_lib.inc
#include ../include/i2c_lib.inc


            org     2000h
start:      br      main


            ; Build information

            ever

            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument
        
main:       lda     ra                  ; check for any options
            smi     ' '                 ; move past any spaces
            lbz     main
            dec     ra                  ; move back to non-space character
            lda     ra                  ; get byte
            lbz     rd_c_data           ; if no argument do default (read Celsius)
            smi     '-'                 ; check for dash 
            lbnz    usage               ; anything but dash is an error
            lda     ra                  ; get next option
            smi     'c'                 ; check for read Celsius option
            lbz     rd_c_data
            lbnf    usage               ; anything less than 'c', is an error
            smi     1                   ; check for disable option 'd'-'c'=1
            lbz     heat_off
            smi     1                   ; check for enable option 'e'-'d' = 1
            lbz     heat_on             ; e means enable heater
            smi     1                   ; check for fahrenheit option 'f'-'e' = 1
            lbz     rd_f_data           ; f means read Fahrenheit
            smi     2                   ; check for heater state option 'h'-'f' = 2
            lbz     heat_state
            lbnf    usage               ; anything less than an h, is an error

            smi     10                  ; check for reset, 'r'-'h' = 10
            lbz     init_reset          ; read status and display it
            lbnf    usage               ; anything less than an r, is an error
            
            smi     1                   ; check for read status, 's'-'r' = 1
            lbz     read_stat           ; read status and display it
            
            lbr     usage               ; anything else, is an error

init_reset: call    i2c_init            ; initialize i2c bus
            call    sht31_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found
            
            call    sht31_init          ; reset the SHT31 temp/humidity sensor
            lbdf    errmsg              ; DF=1 means an error occurred 
            return
              
heat_off:   call    i2c_init            ; initialize i2c bus
            call    sht31_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found
            
            call    sht31_ready         ; check if already initialized
            lbdf    errmsg              ; DF=1 means an error occurred
            lbnz    h_off_rdy            ; if D nonzero, already initialized
            
            call    sht31_init          ; reset SHT31 temp/humidity sensor
            lbdf    errmsg              ; DF=1 means an error occurred 

h_off_rdy:  ldi     0                   ; D=0 means turn heater off
            call    sht31_set_heater    ; turn SHT31 heater off
            lbdf    errmsg              ; DF=1 means an error occurred  
            lbr     heat_state         
            
heat_on:    call    i2c_init            ; initialize i2c bus
            call    sht31_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    sht31_ready         ; check if already initialized
            lbdf    errmsg              ; DF=1 means an error occurred
            lbnz    h_on_rdy            ; if D nonzero, already initialized
                        
            call    sht31_init          ; reset SHT31 temp/humidity sensor
            lbdf    errmsg              ; DF=1 means an error occurred 

h_on_rdy:   ldi     1                   ; D=1 means turn heater on
            call    sht31_set_heater    ; turn SHT31 heater on
            lbdf    errmsg              ; DF=1 means an error occurred  
            lbr     heat_state                                 
                      
rd_c_data:  call    i2c_init            ; initialize i2c bus
            call    sht31_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    sht31_ready         ; check if already initialized
            lbdf    errmsg              ; DF=1 means an error occurred
            lbnz    rd_c_rdy            ; if D nonzero, already initialized            

            call   sht31_init           ; reset SHT31 temp/humidity sensor
            lbdf   errmsg               ; DF=1 means an error occurred
                      
rd_c_rdy:   call    sht31_read_data     ; read SHT31 temp/humidity data
            lbdf    errmsg              ; DF=1 means an error occurred

            call    temp_hdr            ; print temperature label    
            call    sht31_temperature_c ; get temperature string
            call    o_msg               ; print temperature string
            call    prt_eol             ; print end of line

            call    hum_hdr             ; print humidity label
            call    sht31_humidity      ; get humidity string
            call    o_msg               ; print humidity string            
            call    prt_eol             ; print end of line

            call    dp_hdr              ; print dewpoint label
            call    sht31_dewpoint_c    ; get dewpoint string
            call    o_msg               ; print humidity string
            call    prt_eol             ; print end of line
            return
            
rd_f_data:  call    i2c_init            ; initialize i2c bus
            call    sht31_avail         ; check i2c bus for relay
            lbdf    no_id               ; exit with error msg, if not found

            call    sht31_ready         ; check if already initialized
            lbdf    errmsg              ; DF=1 means an error occurred
            lbnz    rd_f_rdy            ; if D nonzero, already initialized
            

            call   sht31_init           ; reset SHT31 temp/humidity sensor
            lbdf   errmsg               ; DF=1 means an error occurred
          
rd_f_rdy:   call    sht31_read_data     ; read SHT31 temp/humidity data
            lbdf    errmsg              ; DF=1 means an error occurred

            call    temp_hdr            ; print temperature label
            call    sht31_temperature_f ; get temperature string
            call    o_msg               ; print temperature string
            call    prt_eol             ; print end of line

            call    hum_hdr             ; print humidity label
            call    sht31_humidity      ; get humidity string
            call    o_msg               ; print humidity string            
            call    prt_eol             ; print end of line

            call    dp_hdr              ; print dewpoint label
            call    sht31_dewpoint_f    ; get dewpoint string
            call    o_msg               ; print humidity string
            call    prt_eol             ; print end of line
            return
            
read_stat:  call    sht31_read_status   ; rd holds status value         
            lbdf    errmsg              ; exit if failed to read status 
            
            load    rf, hex_stat        ; point rf to buffer
            call    f_hexout4           ; convert status bytes to string
            
            call    o_inmsg             ; print status msg header
            db      'Status: ',0        
            
            load    rf, hex_stat        ; print status hex values
            call    o_msg
            return                      ; Exit to Elf/os        
            
temp_hdr:   call    o_inmsg             ; label for temperature
            db      'Temp: ',0                
            return 

hum_hdr:    call    o_inmsg             ; label for humidity
            db      'Humidity: ',0                
            return 
                        
dp_hdr:     call    o_inmsg             ; label for dewpoint
            db      'Dewpoint: ',0                
            return 
            
prt_eol:    call    o_inmsg             ; print eol
            db      10,13,0 
            return                      
            
        
heat_state: call    sht31_get_heater    ; check the status of the heater
            lbdf    errmsg              ; DF=1 means an error occurred
            lbz     htr_off             ; D=0 means heater is off
            
            call    o_inmsg       
            db      'Heater is ON.',10,13,0
            return                      ; Exit to Elf/os

htr_off:    call    o_inmsg
            db      'Heater is OFF.',10,13,0
            return                      ; Exit to Elf/os

no_id:      call    o_inmsg   
            db      'Device not found.',10,13,0
            abend                       ; return to Elf/os with error code

errmsg:     call    o_inmsg   
            db      'Error accessing device.',10,13,0
            abend                       ; return to Elf/os with error code
            
usage:      call    o_inmsg             ; otherwise display usage message
            db      'Usage: sht31 (-c|-d|-e|-f|-h|-r|-s)',10,13,0
            call    o_inmsg
            db      'Options: -c Celsius readings (default)',10,13,0
            call    o_inmsg
            db      ' -d Disable sht31 heater',10,13,0
            call    o_inmsg
            db      ' -e Enable sht31 heater',10,13,0
            call    o_inmsg
            db      ' -f Fahrenheit readings',10,13,0
            call    o_inmsg
            db      ' -h Heater state',10,13,0
            call    o_inmsg
            db      ' -r Reset sht31 sensor',10,13,0
            call    o_inmsg
            db      ' -s Status for sht31',10,13,0

            return                      ; and return to Elf/os

hex_stat:   db  0,0,0,0,0               ; 16-bit status 

            end     start
