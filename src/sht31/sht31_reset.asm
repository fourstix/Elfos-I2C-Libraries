;-------------------------------------------------------------------------------
; sht31_reset - a routine to reset the SHT31 temperature and humidity 
; sensor with I2C using the PIO Expansion Board and I2C adaptor for the 
; 1802/Mini Computer with the RTC Expansion card.
;
; Copyright 2023 by Gaston Williams
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
; Adafruit SHT31 Temperature & Humidity Sensor
; Copyright 2019-2023 by Adafruit Industries
; Please see https://www.adafruit.com/product/2857 for more info
;-------------------------------------------------------------------------------

#include    ../include/ops.inc
#include    ../include/bios.inc
#include    ../include/sht31_lib.inc  
#include    ../include/i2c_lib.inc  
#include    ../include/util_lib.inc  
#include    ../include/sht31_def.inc


;-------------------------------------------------------------------------------
; This routine sends the command to soft reset the sensor.
; Returns: 
;   DF = 0 on success, DF = 1 on error
;-------------------------------------------------------------------------------

            proc    sht31_reset
            push    rc                  ; save delay counter register

            call    i2c_wrbuf
            db      I2C_ADDR, 2         ; 2 bytes in command
            dw      reset_cmd           ; send soft reset command
            lbdf    err_exit            ; if error, exit immediately

            mov     rc, DELAY_10MS      ; delay about 10 ms for reset
            call    util_delay
                      
err_exit:   pop     rc                  ; restore delay counter
            return

reset_cmd:  db      $30,$A2
            endp
